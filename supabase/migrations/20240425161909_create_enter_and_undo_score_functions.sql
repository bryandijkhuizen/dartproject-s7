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


CREATE OR REPLACE FUNCTION record_turn(player_id uuid, leg_id bigint, score bigint)
RETURNS TABLE(new_score bigint, leg_winner_id uuid) AS $$
DECLARE
    current_score bigint;
BEGIN
    -- Bereken de huidige score gebaseerd op de laatste turn in deze leg.
    SELECT current_score INTO current_score FROM turn WHERE leg_id = leg_id ORDER BY id DESC LIMIT 1;
    new_score := current_score - score;

    -- Insert de nieuwe turn in de database.
    INSERT INTO turn (player_id, leg_id, score, current_score) VALUES (player_id, leg_id, score, new_score);

    -- Controleer of de leg gewonnen is (score van 0).
    IF new_score = 0 THEN
        leg_winner_id := player_id;
        UPDATE "leg" SET winner_id = leg_winner_id WHERE id = leg_id;
        RETURN QUERY SELECT new_score, leg_winner_id;
    ELSE
        RETURN QUERY SELECT new_score, NULL::uuid AS leg_winner_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION undo_last_score(leg_id bigint)
RETURNS TABLE(removed_score bigint, updated_current_score bigint) AS $$
DECLARE
    last_turn RECORD;
BEGIN
    -- Selecteer de laatste turn voor de opgegeven leg.
    SELECT * INTO last_turn FROM turn WHERE leg_id = leg_id ORDER BY id DESC LIMIT 1;

    -- Verwijder de laatste turn.
    DELETE FROM turn WHERE id = last_turn.id;

    -- Update de current_score in de leg tabel als de leg nog actief is (geen winnaar).
    UPDATE leg SET current_score = last_turn.current_score + last_turn.score
    WHERE id = leg_id AND winner_id IS NULL RETURNING current_score INTO updated_current_score;

    -- Retourneer de verwijderde score en de bijgewerkte huidige score.
    RETURN QUERY SELECT last_turn.score AS removed_score, updated_current_score;
END;
$$ LANGUAGE plpgsql;
