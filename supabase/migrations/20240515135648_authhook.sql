set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    claims jsonb;
    my_user_id uuid;
    user_system_permissions varchar[];
BEGIN
    my_user_id := (event->>'user_id')::uuid;
    claims := event->'claims';
    -- Check if 'permissions' exists in claims
      if jsonb_typeof(claims->'app_metadata') is null then
        -- If 'permissions' does not exist, create an empty object
        claims := jsonb_set(claims, '{app_metadata}', '{}');
      end if;

    SELECT array_agg(DISTINCT p.name) AS permissions
    into user_system_permissions
    FROM public.user_role ur
    JOIN public.role_permission rp ON ur.role_id = rp.role_id
    JOIN public.permission p ON rp.permission_id = p.id
    WHERE ur.user_id = my_user_id;

    claims := jsonb_set(claims, '{app_metadata, system_permissions}', to_jsonb(user_system_permissions));
    -- Update the 'claims' object in the original event
    event := jsonb_set(event, '{claims}', claims);

    RETURN event;
END;
$function$
;

grant select on table "public"."permission" to "supabase_auth_admin";

grant select on table "public"."role_permission" to "supabase_auth_admin";

grant select on table "public"."user_role" to "supabase_auth_admin";

create policy "Enable read access for all users"
on "public"."club_role"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."club_role_permission"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."permission"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."role_permission"
as permissive
for select
to public
using (true);
