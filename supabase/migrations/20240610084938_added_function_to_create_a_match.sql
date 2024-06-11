set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_match(p_player_1_id uuid, p_player_2_id uuid, p_date timestamp without time zone, p_location text, p_set_target integer, p_leg_target integer, p_starting_score integer, p_winner_id uuid, p_starting_player_id uuid, p_is_friendly boolean)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    new_match_id INTEGER;
BEGIN
    INSERT INTO match (
        player_1_id,
        player_2_id,
        date,
        location,
        set_target,
        leg_target,
        starting_score,
        winner_id,
        starting_player_id,
        is_friendly
    ) VALUES (
        p_player_1_id,
        p_player_2_id,
        p_date,
        p_location,
        p_set_target,
        p_leg_target,
        p_starting_score,
        p_winner_id,
        p_starting_player_id,
        p_is_friendly
    )
    RETURNING id INTO new_match_id;

    RETURN new_match_id;
END;
$function$
;