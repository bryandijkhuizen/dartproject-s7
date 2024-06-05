set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.save_player_ids(match_data json)
 RETURNS result_type
 LANGUAGE plpgsql
AS $function$
DECLARE
    elem JSON;
    result result_type;
    player_1_id UUID;
    player_2_id UUID;
BEGIN
    FOR elem IN SELECT * FROM json_array_elements(match_data)
    LOOP
        BEGIN

            player_1_id := NULLIF(elem->>'player_1_id', '')::UUID;
            player_2_id := NULLIF(elem->>'player_2_id', '')::UUID;

            INSERT INTO match (player_1_id, player_2_id, date, location, set_target, leg_target, starting_score)
            VALUES (
                player_1_id,
                player_2_id,
                (elem->>'date')::timestamp with time zone,
                (elem->>'location')::text,
                (elem->>'set_target')::bigint,
                (elem->>'leg_target')::bigint,
                (elem->>'starting_score')::bigint
            );
            result.success := TRUE;
            result.message := '';
        EXCEPTION
            WHEN unique_violation THEN
                result.success := FALSE;
                result.message := 'A match with this information already exists.';
            WHEN foreign_key_violation THEN
                result.success := FALSE;
                result.message := 'A referenced entity does not exist.';
            WHEN check_violation THEN
                result.success := FALSE;
                result.message := 'A value fails a check constraint.';
            WHEN data_exception THEN
                result.success := FALSE;
                result.message := 'Invalid data format.';
            WHEN insufficient_privilege THEN
                result.success := FALSE;
                result.message := 'You do not have permission to perform this action.';
            WHEN others THEN
                result.success := FALSE;
                result.message := 'An error occurred. Please try again later.';
        END;
    END LOOP;
    RETURN result;
END;
$function$
;


