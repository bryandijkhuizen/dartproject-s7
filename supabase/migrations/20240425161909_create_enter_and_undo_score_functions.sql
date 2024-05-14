CREATE OR REPLACE FUNCTION create_set(match_id bigint)
RETURNS TABLE(set_id bigint) AS $$
BEGIN
    INSERT INTO "set" (match_id) VALUES (match_id) RETURNING id INTO set_id;
    RETURN QUERY SELECT set_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION create_leg(set_id bigint)
RETURNS TABLE(leg_id bigint) AS $$
BEGIN
    INSERT INTO "leg" (set_id) VALUES (set_id) RETURNING id INTO leg_id;
    RETURN QUERY SELECT leg_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION record_turn(player_id uuid, new_leg_id bigint, score bigint)
RETURNS TABLE(new_score bigint, new_score2 bigint, leg_winner_id uuid) AS $$
DECLARE
    current_score bigint;
    current_score2 bigint;
    starting_score bigint;
BEGIN
    SELECT m.starting_score INTO starting_score 
    FROM "match" m 
    JOIN "set" s ON m.id = s.match_id 
    JOIN "leg" l ON s.id = l.set_id 
    WHERE l.id = new_leg_id;

    IF starting_score IS NULL THEN
        RAISE EXCEPTION 'Starting score not found for the match';
    END IF;

    SELECT t.current_score, t.current_score2 INTO current_score, current_score2
    FROM turn t
    WHERE t.leg_id = new_leg_id 
    ORDER BY t.id DESC LIMIT 1;

    IF current_score IS NULL THEN
        current_score := starting_score;
    END IF;
    
    IF current_score2 IS NULL THEN
        current_score2 := starting_score;
    END IF;

    IF player_id = (SELECT player_1_id FROM "match" WHERE id = (SELECT match_id FROM "set" WHERE id = (SELECT set_id FROM "leg" WHERE id = new_leg_id))) THEN
        new_score := current_score - score;
        new_score2 := current_score2;
    ELSE
        new_score := current_score;
        new_score2 := current_score2 - score;
    END IF;

    INSERT INTO turn (player_id, leg_id, score, current_score, current_score2) VALUES (player_id, new_leg_id, score, new_score, new_score2);

    IF new_score = 0 OR new_score2 = 0 THEN
        leg_winner_id := player_id;
        UPDATE "leg" SET winner_id = leg_winner_id WHERE id = new_leg_id;
    ELSE
        leg_winner_id := NULL;
    END IF;

    RETURN QUERY SELECT new_score, new_score2, leg_winner_id;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION undo_last_score(leg_id bigint)
RETURNS TABLE(removed_score bigint, updated_current_score bigint, updated_current_score2 bigint) AS $$
DECLARE
    last_turn RECORD;
BEGIN
    SELECT * INTO last_turn FROM turn WHERE leg_id = leg_id ORDER BY id DESC LIMIT 1;

    DELETE FROM turn WHERE id = last_turn.id;

    UPDATE leg SET current_score = last_turn.current_score + last_turn.score,
                   current_score2 = last_turn.current_score2 + last_turn.score
    WHERE id = leg_id AND winner_id IS NULL RETURNING current_score, current_score2 INTO updated_current_score, updated_current_score2;

    RETURN QUERY SELECT last_turn.score AS removed_score, updated_current_score, updated_current_score2;
END;
$$ LANGUAGE plpgsql;
