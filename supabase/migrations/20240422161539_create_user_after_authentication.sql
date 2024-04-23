set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.create_new_player()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
 SET search_path TO 'public'
AS $function$BEGIN
    -- Insert into public.user table with data from auth.users
    INSERT INTO public.user (id, first_name, last_name)
    VALUES (NEW.id, NEW.raw_user_meta_data->>'first_name', NEW.raw_user_meta_data->>'last_name');

    -- Assign player role
    INSERT INTO user_role (user_id, role_id)
    VALUES (NEW.id, (SELECT id FROM role WHERE name = 'Player'));

    RETURN NEW;
    
END;$function$
;

CREATE OR REPLACE FUNCTION public.update_auth_user_meta_data()
 RETURNS trigger
 LANGUAGE plpgsql
AS $function$
BEGIN
    -- Update raw_user_meta_data in auth.users based on which field is updated and only if they differ
    IF TG_OP = 'UPDATE' THEN
        IF NEW.first_name IS DISTINCT FROM OLD.first_name THEN
            UPDATE auth.users
            SET raw_user_meta_data = jsonb_set(
                                        COALESCE(auth.users.raw_user_meta_data, '{}'::jsonb),
                                        '{first_name}',
                                        to_jsonb(NEW.first_name),
                                        true
                                      )
            WHERE auth.users.id = NEW.id;
        END IF;
        
        IF NEW.last_name IS DISTINCT FROM OLD.last_name THEN
            UPDATE auth.users
            SET raw_user_meta_data = jsonb_set(
                                        COALESCE(auth.users.raw_user_meta_data, '{}'::jsonb),
                                        '{last_name}',
                                        to_jsonb(NEW.last_name),
                                        true
                                      )
            WHERE auth.users.id = NEW.id;
        END IF;
    END IF;

    RETURN NEW;
END;
$function$
;

create policy "insert_own_user_row"
on "public"."user"
as permissive
for insert
to public
with check ((( SELECT auth.uid() AS uid) = id));


create policy "user_table_is_publicly_accessible"
on "public"."user"
as permissive
for select
to public
using (true);


CREATE TRIGGER on_user_name_update AFTER UPDATE OF first_name, last_name ON public."user" FOR EACH ROW EXECUTE FUNCTION update_auth_user_meta_data();


CREATE TRIGGER on_auth_user_insert AFTER INSERT ON auth.users FOR EACH ROW EXECUTE FUNCTION create_new_player();


