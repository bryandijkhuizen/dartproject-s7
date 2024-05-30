set check_function_bodies = off;

create type "public"."result_type" as ("success" boolean, "message" text);

CREATE OR REPLACE FUNCTION public.create_club(p_name text, p_address text, p_postal_code text, p_city text, p_email text, p_phone text, p_note text DEFAULT ''::text)
 RETURNS result_type
 LANGUAGE plpgsql
AS $function$DECLARE
    result result_type;
BEGIN
    BEGIN
        INSERT INTO club (
            name,
            address,
            postal_code,
            city,
            owner_id,
            email_address,
            phone_number,
            banner_image_url,
            application_status,
            note
        ) VALUES (
            p_name,
            p_address,
            p_postal_code,
            p_city,
            DEFAULT,
            p_email,
            p_phone,
            DEFAULT,  -- Use the default value for banner_image_url
            'Pending application',
            p_note
        );
        
        result.success := TRUE;
        result.message := '';
    EXCEPTION
    WHEN unique_violation THEN
        result.success := FALSE;
        result.message := 'A club with this information already exists.';
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

    RETURN result;
END;$function$
;

CREATE OR REPLACE FUNCTION public.count_owned_clubs(user_id uuid)
 RETURNS integer
 LANGUAGE plpgsql
AS $function$
DECLARE
    club_count INTEGER;
BEGIN
    SELECT COUNT(*) INTO club_count
    FROM club
    WHERE owner_id = user_id;
    
    RETURN club_count;
END;
$function$
;

create policy "Clubs can be created by anyone who doesnt own a club"
on "public"."club"
as permissive
for insert
to authenticated
with check ((count_owned_clubs(auth.uid()) < 1));


