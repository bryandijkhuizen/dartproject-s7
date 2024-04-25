CREATE OR REPLACE FUNCTION public.enter_score(leg_id uuid, player_id uuid, score integer)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
  INSERT INTO turns (leg_id, player_id, score)
  VALUES (leg_id, player_id, score);
END;
$$;

CREATE OR REPLACE FUNCTION public.undo_last_score(leg_id uuid, player_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    last_turn_id uuid;
BEGIN
    SELECT id INTO last_turn_id FROM turns
    WHERE leg_id = leg_id AND player_id = player_id
    ORDER BY id DESC LIMIT 1;

    IF last_turn_id IS NOT NULL THEN
        DELETE FROM turns WHERE id = last_turn_id;
    END IF;
END;
$$;


