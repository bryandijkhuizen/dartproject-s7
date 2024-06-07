create type "public"."match_details_type" as ("id" bigint, "player_1_id" uuid, "player_2_id" uuid, "date" timestamp with time zone, "location" text, "set_target" bigint, "leg_target" bigint, "starting_score" bigint, "winner_id" uuid, "starting_player_id" uuid, "player_1_last_name" text, "player_2_last_name" text);

create type "public"."get_next_match_by_user_id_result_type" as ("success" boolean, "message" text, "data" match_details_type);

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_next_match_by_user_id(user_id uuid)
 RETURNS get_next_match_by_user_id_result_type
 LANGUAGE plpgsql
AS $function$DECLARE
    result get_next_match_by_user_id_result_type;
    match_details match_details_type;
    exception_code TEXT;
BEGIN
    SELECT
        m.id,
        m.player_1_id,
        m.player_2_id,
        m.date,
        m.location,
        m.set_target,
        m.leg_target,
        m.starting_score,
        m.winner_id,
        m.starting_player_id,
        p1.last_name AS player_1_last_name,
        p2.last_name AS player_2_last_name
    INTO match_details
    FROM
        public.match m
        LEFT JOIN public.user p1 ON m.player_1_id = p1.id
        LEFT JOIN public.user p2 ON m.player_2_id = p2.id
    WHERE
        (m.player_1_id = user_id OR m.player_2_id = user_id)
        AND m.date > NOW()
    ORDER BY
        m.date
    LIMIT 1;


    IF match_details.id IS NULL THEN
        result := (false, 'No match found', NULL);
    ELSE
        result := (true, 'Next match found', match_details);
    END IF;

    RETURN result;

    EXCEPTION
    WHEN insufficient_privilege THEN
        -- Handle policy violation
        result := (false, 'Permission denied to access match data', NULL);
        RETURN result;
    WHEN OTHERS THEN
        exception_code := sqlstate;

        -- Handle any other exceptions
        result := (false, 'Error with code: ' || exception_code || ' occurred.', NULL);
        RETURN result;
END;$function$
;