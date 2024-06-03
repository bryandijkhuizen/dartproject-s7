set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.add_user_clubroles(current_user_id uuid, role_names character varying[], current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    role_name varchar;
    current_role_id INT;
BEGIN
     -- Iterate over the list of role names
    FOREACH role_name IN ARRAY role_names LOOP
        -- Find the role_id corresponding to the role_name
        SELECT id INTO current_role_id FROM club_role WHERE name = role_name;

        IF NOT EXISTS (SELECT 1 FROM user_club_role WHERE current_user_id = user_id AND club_role_id = current_role_id) THEN
          INSERT INTO user_club_role (user_id, club_role_id, club_id) VALUES (current_user_id, current_role_id, current_club_id);
        END IF;
        
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.add_user_roles(current_user_id uuid, role_names character varying[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    role_name varchar;
    current_role_id INT;
BEGIN
     -- Iterate over the list of role names
    FOREACH role_name IN ARRAY role_names LOOP
        -- Find the role_id corresponding to the role_name
        SELECT id INTO current_role_id FROM role WHERE name = role_name;

        IF NOT EXISTS (SELECT 1 FROM user_role WHERE current_user_id = user_id AND role_id = current_role_id) THEN
          INSERT INTO user_role (user_id, role_id) VALUES (current_user_id, current_role_id);
        END IF;
        
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.custom_access_token_hook(event jsonb)
 RETURNS jsonb
 LANGUAGE plpgsql
AS $function$
DECLARE
    claims jsonb;
    my_user_id uuid;
    permission_data jsonb;
    system_permissions varchar[];
    club_permissions jsonb;
BEGIN
    my_user_id := (event->>'user_id')::uuid;
    claims := event->'claims';

    -- Check if 'permissions' exists in claims
    IF jsonb_typeof(claims->'app_metadata') IS NULL THEN
        -- If 'permissions' does not exist, create an empty object
        claims := jsonb_set(claims, '{app_metadata}', '{}');
    END IF;

    -- Retrieve system_permissions
    SELECT array_agg(DISTINCT p.name)
    INTO system_permissions
    FROM public.user_role ur
    JOIN public.role_permission rp ON ur.role_id = rp.role_id
    JOIN public.permission p ON rp.permission_id = p.id
    WHERE ur.user_id = my_user_id;

    -- Retrieve club_permissions with club id using a CTE
    WITH club_permissions_agg AS (
        SELECT ucr.club_id, array_agg(DISTINCT p.name) AS permissions
        FROM public.user_club_role ucr
        JOIN public.club_role_permission crp ON ucr.club_role_id = crp.club_role_id
        JOIN public.permission p ON crp.permission_id = p.id
        WHERE ucr.user_id = my_user_id
        GROUP BY ucr.club_id
    )
    SELECT jsonb_object_agg(club_id, to_jsonb(permissions))
    INTO club_permissions
    FROM club_permissions_agg;

    permission_data := jsonb_build_object(
        'system_permissions', system_permissions,
        'club_permissions', club_permissions
    );

    claims := jsonb_set(claims, '{app_metadata, app_permissions}', permission_data);
    -- Update the 'claims' object in the original event
    event := jsonb_set(event, '{claims}', claims);

    RETURN event;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_user_clubroles(current_user_id uuid, role_names character varying[], current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    role_name varchar;
    current_role_id INT;
BEGIN
     -- Iterate over the list of role names
    FOREACH role_name IN ARRAY role_names LOOP
        -- Find the role_id corresponding to the role_name
        SELECT id INTO current_role_id FROM club_role WHERE name = role_name;

        IF EXISTS (SELECT 1 FROM user_club_role WHERE current_user_id = user_id AND club_role_id = current_role_id AND club_id = current_club_id ) THEN
          delete from user_club_role where current_user_id = user_id AND club_role_id = current_role_id AND club_id = current_club_id;
        END IF;
        
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_user_roles(current_user_id uuid, role_names character varying[])
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
    role_name varchar;
    current_role_id INT;
BEGIN
     -- Iterate over the list of role names
    FOREACH role_name IN ARRAY role_names LOOP
        -- Find the role_id corresponding to the role_name
        SELECT id INTO current_role_id FROM role WHERE name = role_name;

        IF EXISTS (SELECT 1 FROM user_role WHERE current_user_id = user_id AND role_id = current_role_id) THEN
          delete from user_role where current_user_id = user_id AND role_id = current_role_id;
        END IF;
        
    END LOOP;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_all_users_and_clubroles(name_filter text, role_filter text, club_id integer, current_user_id uuid)
 RETURNS TABLE(id uuid, first_name text, last_name text, avatarid integer, full_name text, roles character varying[])
 LANGUAGE sql
AS $function$
SELECT u.*,
       concat(u.first_name, ' ', u.last_name) AS full_name,
       (SELECT array_agg(r.name)
        FROM user_club_role ur
        JOIN club_role r ON ur.club_role_id = r.id
        WHERE ur.user_id = u.id) AS roles
FROM "user" u
WHERE ($1 IS NULL OR $1 = '' OR (u.first_name ILIKE '%' || $1 || '%' OR u.last_name ILIKE '%' || $1 || '%'))
  AND ($2 IS NULL OR $2 = '' OR EXISTS (SELECT 1 FROM user_club_role ur JOIN club_role r ON ur.club_role_id = r.id WHERE ur.user_id = u.id AND r.name ILIKE '%' || $2 || '%'))
  AND ($3 IS NULL OR $3 = 0 OR EXISTS (SELECT 1 FROM user_club_role ur JOIN club_role r ON ur.club_role_id = r.id WHERE ur.user_id = u.id AND ur.club_id = $3))
  AND NOT EXISTS (SELECT 1 FROM user WHERE id = current_user_id);
$function$
;

CREATE OR REPLACE FUNCTION public.get_all_users_and_roles(name_filter text, role_filter text, current_user_id uuid)
 RETURNS TABLE(id uuid, first_name text, last_name text, avatarid integer, full_name text, roles character varying[])
 LANGUAGE sql
AS $function$
SELECT u.*,
       concat(u.first_name, ' ', u.last_name) AS full_name,
       (SELECT array_agg(r.name)
        FROM user_role ur
        JOIN role r ON ur.role_id = r.id
        WHERE ur.user_id = u.id) AS roles
FROM "user" u
WHERE ($1 IS NULL OR $1 = '' OR (u.first_name ILIKE '%' || $1 || '%' OR u.last_name ILIKE '%' || $1 || '%'))
  AND ($2 IS NULL OR $2 = '' OR EXISTS (SELECT 1 FROM user_role ur JOIN role r ON ur.role_id = r.id WHERE ur.user_id = u.id AND r.name ILIKE '%' || $2 || '%'))
  AND NOT EXISTS (SELECT 1 FROM user WHERE id = current_user_id);
$function$
;

CREATE OR REPLACE FUNCTION public.get_club_role_names()
 RETURNS TABLE(role_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT club_role.name FROM club_role;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_current_user_and_clubrole_information(current_user_id uuid, current_club_id integer)
 RETURNS TABLE(id uuid, avatar_url text, full_name text, my_roles character varying[], all_roles character varying[])
 LANGUAGE sql
AS $function$select u.id, 
       a.url as avatar_url, 
       concat(u.first_name, ' ', u.last_name) as full_name,
       (select array_agg(r.name) 
        from user_club_role ur
        join club_role r on ur.club_role_id = r.id
        where (ur.user_id = u.id and ur.club_id = current_club_id)and r.name != 'Club administrator') as myroles,
       (select array_agg(r.name) 
        from club_role r 
        where r.id not in (
          select club_role_id 
          from user_club_role 
          where (user_id = u.id 
          and club_id != current_club_id) or r.name = 'Club administrator')) as all_roles
from "user" u
join avatar a on u.avatar_id = a.id
where u.id = current_user_id;$function$
;

CREATE OR REPLACE FUNCTION public.get_current_user_and_role_information(current_user_id uuid)
 RETURNS TABLE(id uuid, avatar_url text, full_name text, my_roles character varying[], all_roles character varying[])
 LANGUAGE sql
AS $function$select u.id, 
       a.url as avatar_url, 
       concat(u.first_name, ' ', u.last_name) as full_name,
       (select array_agg(r.name) 
        from user_role ur
        join role r on ur.role_id = r.id
        where ur.user_id = u.id) as myroles,
       (select array_agg(r.name) 
        from role r) as allroles
from "user" u
join avatar a on u.avatar_id = a.id
where u.id = current_user_id;$function$
;

CREATE OR REPLACE FUNCTION public.get_role_names()
 RETURNS TABLE(role_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY SELECT role.name FROM role;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_user_clubs_and_admin_roles(current_user_id uuid)
 RETURNS TABLE(club_ids bigint[], club_names character varying[], admin_club_id bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    SELECT array_agg(c.id) into club_ids
    FROM public.user_club uc
    JOIN public.club c ON uc.club_id = c.id
    WHERE uc.user_id = current_user_id;

    SELECT array_agg(c.name) into club_names
    FROM public.user_club uc
    JOIN public.club c ON uc.club_id = c.id
    WHERE uc.user_id = current_user_id;

    SELECT ucr.club_id into admin_club_id
    FROM public.user_club_role ucr
    JOIN public.club_role cr ON ucr.club_role_id = cr.id
    WHERE ucr.user_id = current_user_id AND cr.name = 'Club administrator';

    RETURN NEXT;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_club_administrator(current_user_id uuid, new_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
DECLARE
  v_exists BOOLEAN;
BEGIN
  -- Check if the user already has the admin role for the new club
  RAISE NOTICE 'Checking if the user already has the admin role for the new club.';
  SELECT EXISTS (
    SELECT 1
    FROM user_club_role
    WHERE user_id = current_user_id
      AND club_role_id = 4
      AND club_id = new_club_id
  ) INTO v_exists;

  RAISE NOTICE 'Existence check completed: %', v_exists;

  IF NOT v_exists THEN
    RAISE NOTICE 'User does not have the admin role for the new club. Proceeding with deletion.';
    -- Delete any existing admin role assignments for the user
    DELETE FROM user_club_role
    WHERE user_id = current_user_id
      AND club_role_id = 4;
    
    RAISE NOTICE 'Existing admin role assignments deleted.';

    -- Assign the new admin role if the new_club_id is not 0
    IF new_club_id != 0 THEN
      RAISE NOTICE 'Assigning new admin role.';
      INSERT INTO user_club_role (user_id, club_role_id, club_id)
      VALUES (current_user_id, 4, new_club_id);
      RAISE NOTICE 'New admin role assigned.';
    END IF;
  ELSE
    RAISE NOTICE 'User already has the admin role for the new club. No action needed.';
  END IF;
EXCEPTION
  WHEN OTHERS THEN
    RAISE NOTICE 'An error occurred: %', SQLERRM;
END;
$function$
;

grant select on table "public"."club" to "supabase_auth_admin";

grant select on table "public"."club_role" to "supabase_auth_admin";

grant select on table "public"."club_role_permission" to "supabase_auth_admin";

grant select on table "public"."permission" to "supabase_auth_admin";

grant select on table "public"."role" to "supabase_auth_admin";

grant select on table "public"."role_permission" to "supabase_auth_admin";

grant select on table "public"."user" to "supabase_auth_admin";

grant select on table "public"."user_club_role" to "supabase_auth_admin";

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
on "public"."role"
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


create policy "Enable read access for all users"
on "public"."user"
as permissive
for select
to public
using (true);


create policy "Enable read access for all users"
on "public"."user_club_role"
as permissive
for select
to public
using (true);


create policy "allow admins to give roles"
on "public"."user_club_role"
as permissive
for insert
to public
with check ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_role'::text))))));


create policy "allow admins to remove roles"
on "public"."user_club_role"
as permissive
for delete
to public
using ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_role'::text))))));


create policy "allow club admins to give roles"
on "public"."user_club_role"
as permissive
for insert
to public
with check ((auth.uid() IN ( SELECT user_club_role_1.user_id
   FROM user_club_role user_club_role_1
  WHERE (user_club_role_1.club_role_id IN ( SELECT user_club_role_2.club_role_id
           FROM ((user_club_role user_club_role_2
             JOIN club_role_permission ON ((user_club_role_2.club_role_id = club_role_permission.club_role_id)))
             JOIN permission ON ((club_role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_clubrole'::text))))));


create policy "allow club admins to remove roles"
on "public"."user_club_role"
as permissive
for delete
to public
using ((auth.uid() IN ( SELECT user_club_role_1.user_id
   FROM user_club_role user_club_role_1
  WHERE (user_club_role_1.club_role_id IN ( SELECT user_club_role_2.club_role_id
           FROM ((user_club_role user_club_role_2
             JOIN club_role_permission ON ((user_club_role_2.club_role_id = club_role_permission.club_role_id)))
             JOIN permission ON ((club_role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_clubrole'::text))))));


create policy "Enable read access for all users"
on "public"."user_role"
as permissive
for select
to public
using (true);


create policy "allow admins to give roles"
on "public"."user_role"
as permissive
for insert
to public
with check ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_role'::text))))));


create policy "allow admins to remove roles"
on "public"."user_role"
as permissive
for delete
to public
using ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'assign_role'::text))))));



