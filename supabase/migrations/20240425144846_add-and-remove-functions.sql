set check_function_bodies = off;

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

CREATE OR REPLACE FUNCTION public.get_all_users()
 RETURNS TABLE(id uuid, first_name text, last_name text, avatarid integer, full_name text, roles character varying[])
 LANGUAGE sql
AS $function$ 
SELECT u.*, 
       concat(u.first_name, ' ', u.last_name) AS full_name,
       (SELECT array_agg(r.name) 
        FROM user_role ur
        JOIN role r ON ur.role_id = r.id
        WHERE ur.user_id = u.id) AS roles
FROM "user" u;
$function$
;

CREATE OR REPLACE FUNCTION public.get_current_user_roles(current_user_id uuid)
 RETURNS TABLE(id uuid, avatar_url text, full_name text, my_roles character varying[], all_roles character varying[])
 LANGUAGE sql
AS $function$ 
select u.id, 
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
where u.id = current_user_id;
$function$
;

create policy "Enable read access for all users"
on "public"."avatar"
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
on "public"."user"
as permissive
for select
to public
using (true);


create policy "Enable delete access for all users"
on "public"."user_role"
as permissive
for delete
to public
using (true);


create policy "Enable insert access for all users"
on "public"."user_role"
as permissive
for insert
to public
with check (true);


create policy "Enable read access for all users"
on "public"."user_role"
as permissive
for select
to public
using (true);


create policy "Enable update access for all users"
on "public"."user_role"
as permissive
for update
to public
using (true);



