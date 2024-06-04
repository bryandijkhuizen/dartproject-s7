set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_new_player()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$
DECLARE
    full_name TEXT;
    first_name TEXT;
    last_name TEXT;
    updated_meta_data JSONB;
BEGIN
    -- Extract full name from raw_user_meta_data
    full_name := NEW.raw_user_meta_data->>'name';
    
    -- Extract first_name and last_name from raw_user_meta_data if available
    first_name := NEW.raw_user_meta_data->>'first_name';
    last_name := NEW.raw_user_meta_data->>'last_name';

    -- If first_name or last_name is not available, derive from full name
    IF first_name IS NULL THEN
        first_name := split_part(full_name, ' ', 1);
    END IF;
    
    IF last_name IS NULL THEN
        last_name := substring(full_name from position(' ' in full_name) + 1);
    END IF;

    -- Update raw_user_meta_data with first_name and last_name
    updated_meta_data := jsonb_set(
        jsonb_set(NEW.raw_user_meta_data, '{first_name}', to_jsonb(first_name)),
        '{last_name}', to_jsonb(last_name)
    );

    -- Update auth.users table with the updated raw_user_meta_data
    UPDATE auth.users
    SET raw_user_meta_data = updated_meta_data
    WHERE id = NEW.id;

    -- Insert into public.user table
    INSERT INTO public.user (id, first_name, last_name)
    VALUES (NEW.id, first_name, last_name);

    -- Assign player role
    INSERT INTO user_role (user_id, role_id)
    VALUES (NEW.id, (SELECT id FROM role WHERE name = 'Player'));

    RETURN NEW;
END;
$function$
;