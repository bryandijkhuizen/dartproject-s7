CREATE OR REPLACE FUNCTION create_set(p_match_id bigint)
RETURNS TABLE(set_id bigint) AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "set" WHERE match_id = p_match_id AND winner_id IS NULL) THEN
        RETURN QUERY SELECT id FROM "set" WHERE match_id = p_match_id AND winner_id IS NULL;
    ELSE
        INSERT INTO "set" (match_id) VALUES (p_match_id) RETURNING id INTO set_id;
        RETURN QUERY SELECT set_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_leg(p_set_id bigint)
RETURNS TABLE(leg_id bigint) AS $$
BEGIN
    IF EXISTS (SELECT 1 FROM "leg" WHERE set_id = p_set_id AND winner_id IS NULL) THEN
        RETURN QUERY SELECT id FROM "leg" WHERE set_id = p_set_id AND winner_id IS NULL;
    ELSE
        INSERT INTO "leg" (set_id) VALUES (p_set_id) RETURNING id INTO leg_id;
        RETURN QUERY SELECT leg_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION record_turn(
    p_player_id uuid,
    p_new_leg_id bigint,
    p_score bigint,
    p_darts_for_checkout int,
    p_double_attempts int,
    p_double_hit boolean
)
RETURNS TABLE(
    new_score bigint,
    new_score2 bigint,
    leg_winner_id uuid,
    is_dead_throw boolean
) AS $$
DECLARE
    current_score bigint;
    current_score2 bigint;
    starting_score bigint;
BEGIN
    -- Get the starting score for the match
    SELECT m.starting_score INTO starting_score 
    FROM "match" m 
    JOIN "set" s ON m.id = s.match_id 
    JOIN "leg" l ON s.id = l.set_id 
    WHERE l.id = p_new_leg_id;

    IF starting_score IS NULL THEN
        RAISE EXCEPTION 'Starting score not found for the match';
    END IF;

    -- Get the current scores for both players
    SELECT t.current_score, t.current_score2 INTO current_score, current_score2
    FROM turn t
    WHERE t.leg_id = p_new_leg_id 
    ORDER BY t.id DESC LIMIT 1;

    IF current_score IS NULL THEN
        current_score := starting_score;
    END IF;
    
    IF current_score2 IS NULL THEN
        current_score2 := starting_score;
    END IF;

    -- Determine the new scores, handling dead throws
    IF p_player_id = (SELECT player_1_id FROM "match" WHERE id = (SELECT match_id FROM "set" WHERE id = (SELECT set_id FROM "leg" WHERE id = p_new_leg_id))) THEN
        IF current_score - p_score < 0 THEN
            new_score := current_score; -- Dead throw
            is_dead_throw := true;
            p_score := 0; -- Record 0 for a dead throw
        ELSE
            new_score := current_score - p_score;
            is_dead_throw := false;
        END IF;
        new_score2 := current_score2;
    ELSE
        IF current_score2 - p_score < 0 THEN
            new_score2 := current_score2; -- Dead throw
            is_dead_throw := true;
            p_score := 0; -- Record 0 for a dead throw
        ELSE
            new_score2 := current_score2 - p_score;
            is_dead_throw := false;
        END IF;
        new_score := current_score;
    END IF;

    -- Insert the new turn
    INSERT INTO turn (
        player_id, leg_id, score, current_score, current_score2, is_dead_throw,
        darts_for_checkout, double_attempts, double_hit
    ) 
    VALUES (
        p_player_id, p_new_leg_id, p_score, new_score, new_score2, is_dead_throw,
        p_darts_for_checkout, p_double_attempts, p_double_hit
    );

    -- Check if the leg has been won
    IF new_score = 0 OR new_score2 = 0 THEN
        leg_winner_id := p_player_id;
        UPDATE "leg" SET winner_id = leg_winner_id WHERE id = p_new_leg_id;
    ELSE
        leg_winner_id := NULL;
    END IF;

    RETURN QUERY SELECT new_score, new_score2, leg_winner_id, is_dead_throw;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION undo_last_score(p_leg_id bigint)
RETURNS TABLE(removed_score bigint, updated_current_score bigint, updated_current_score2 bigint, last_player_id uuid) AS $$
DECLARE
    last_turn RECORD;
    previous_turn RECORD;
BEGIN
    -- Get the last turn for the given leg
    SELECT * INTO last_turn FROM turn WHERE leg_id = p_leg_id ORDER BY id DESC LIMIT 1;

    -- Delete the last turn
    DELETE FROM turn WHERE id = last_turn.id;

    -- Get the previous turn to determine the updated current scores
    SELECT * INTO previous_turn FROM turn WHERE leg_id = p_leg_id ORDER BY id DESC LIMIT 1;

    -- If there is no previous turn, it means we are back to the starting score
    IF previous_turn IS NULL THEN
        SELECT m.starting_score, m.starting_score AS current_score2 
        INTO updated_current_score, updated_current_score2
        FROM match m 
        JOIN set s ON m.id = s.match_id 
        JOIN leg l ON s.id = l.set_id 
        WHERE l.id = p_leg_id;
        last_player_id := NULL;  -- No previous player if we are at the starting state
    ELSE
        updated_current_score := previous_turn.current_score;
        updated_current_score2 := previous_turn.current_score2;
        last_player_id := previous_turn.player_id;
    END IF;

    -- Return the removed score, updated current scores, and the last player ID
    RETURN QUERY SELECT last_turn.score AS removed_score, updated_current_score, updated_current_score2, last_player_id;
END;
$$ LANGUAGE plpgsql;



CREATE OR REPLACE FUNCTION get_active_set(p_match_id bigint)
RETURNS TABLE(set_id bigint, winner_id uuid) AS $$
BEGIN
    RETURN QUERY 
    SELECT s.id AS set_id, s.winner_id
    FROM "set" s 
    WHERE s.match_id = p_match_id
    ORDER BY s.id ASC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_active_leg(p_set_id bigint)
RETURNS TABLE(leg_id bigint, winner_id uuid) AS $$
BEGIN
    RETURN QUERY 
    SELECT l.id AS leg_id, l.winner_id
    FROM "leg" l 
    WHERE l.set_id = p_set_id
    ORDER BY l.id ASC
    LIMIT 1;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_leg_wins(p_set_id bigint)
RETURNS TABLE(leg_winner_id uuid) AS $$
BEGIN
    RETURN QUERY 
    SELECT l.winner_id AS leg_winner_id
    FROM "leg" l 
    WHERE l.set_id = p_set_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_set_wins(p_match_id bigint)
RETURNS TABLE(set_winner_id uuid) AS $$
BEGIN
    RETURN QUERY 
    SELECT s.winner_id AS set_winner_id
    FROM "set" s 
    WHERE s.match_id = p_match_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_latest_scores(p_leg_id bigint)
RETURNS TABLE(player_id uuid, score bigint, current_score bigint, current_score2 bigint) AS $$
BEGIN
    RETURN QUERY 
    SELECT t.player_id, t.score, t.current_score, t.current_score2
    FROM "turn" t 
    WHERE t.leg_id = p_leg_id
    ORDER BY t.id DESC
    LIMIT 5;
END;
$$ LANGUAGE plpgsql;
