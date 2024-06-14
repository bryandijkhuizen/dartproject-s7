set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_tournament_round(match_data json, current_tournament_id integer, current_round_number integer)
 RETURNS result_type
 LANGUAGE plpgsql
AS $function$
DECLARE
    elem JSON;
    result result_type;
    player_1_id UUID;
    player_2_id UUID;
    inserted_id int;

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
            ) RETURNING id INTO inserted_id;

            -- Attempt to insert into tournament_match
            BEGIN
                INSERT INTO tournament_match (tournament_id, match_id, round_number) 
                VALUES (current_tournament_id, inserted_id, current_round_number);
            EXCEPTION
                WHEN unique_violation THEN
                    result.success := FALSE;
                    result.message := 'A tournament match with this information already exists.';
                    RETURN result;
                WHEN foreign_key_violation THEN
                    result.success := FALSE;
                    result.message := 'A referenced entity in tournament_match does not exist.';
                    RETURN result;
                WHEN check_violation THEN
                    result.success := FALSE;
                    result.message := 'A value in tournament_match fails a check constraint.';
                    RETURN result;
                WHEN data_exception THEN
                    result.success := FALSE;
                    result.message := 'Invalid data format in tournament_match: ' || SQLERRM;
                    RETURN result;
                WHEN others THEN
                    result.success := FALSE;
                    result.message := 'An error occurred in tournament_match: ' || SQLERRM;
                    RETURN result;
            END;

        EXCEPTION
            WHEN unique_violation THEN
                result.success := FALSE;
                result.message := 'A match with this information already exists.';
                RETURN result;
            WHEN foreign_key_violation THEN
                result.success := FALSE;
                result.message := 'A referenced entity in match does not exist.';
                RETURN result;
            WHEN check_violation THEN
                result.success := FALSE;
                result.message := 'A value in match fails a check constraint.';
                RETURN result;
            WHEN data_exception THEN
                result.success := FALSE;
                result.message := 'Invalid data format in match: ' || SQLERRM;
                RETURN result;
            WHEN insufficient_privilege THEN
                result.success := FALSE;
                result.message := 'You do not have permission to perform this action.';
                RETURN result;
            WHEN others THEN
                result.success := FALSE;
                result.message := 'An error occurred in match: ' || SQLERRM;
                RETURN result;
        END;
    END LOOP;
      result.success := TRUE;
      result.message := 'Succesfully created round!';
    
    RETURN result;
END;
$function$
;

create policy "Enable insert access for all users"
on "public"."tournament_match"
as permissive
for insert
to public
with check (true);



