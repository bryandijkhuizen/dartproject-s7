set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.update_public_user()
 RETURNS trigger
 LANGUAGE plpgsql
 SECURITY DEFINER
AS $function$
BEGIN
  IF TG_OP = 'UPDATE' THEN
    -- Check for changes in first_name or last_name
    IF (OLD.raw_user_meta_data->>'first_name' IS DISTINCT FROM NEW.raw_user_meta_data->>'first_name') OR
       (OLD.raw_user_meta_data->>'last_name' IS DISTINCT FROM NEW.raw_user_meta_data->>'last_name') THEN
      
      -- Extract new first_name and last_name values (handle potential nulls)
      UPDATE public.user
      SET first_name = COALESCE(NEW.raw_user_meta_data->>'first_name', OLD.raw_user_meta_data->>'first_name'),
          last_name = COALESCE(NEW.raw_user_meta_data->>'last_name', OLD.raw_user_meta_data->>'last_name')
      WHERE id = NEW.id;
    END IF;
  END IF;
  RETURN NEW;
END;
$function$
;

create policy "Users can update their own data"
on "auth"."users"
as permissive
for update
to public
using ((auth.uid() = id))
with check ((auth.uid() = id));


CREATE TRIGGER on_auth_user_meta_data_update AFTER UPDATE OF raw_user_meta_data ON auth.users FOR EACH ROW EXECUTE FUNCTION update_public_user();


drop trigger if exists "on_user_name_update" on "public"."user";

drop function if exists "public"."update_auth_user_meta_data"();

create policy "update_own_user_policy"
on "public"."user"
as permissive
for update
to public
using ((auth.uid() = id))
with check ((auth.uid() = id));



