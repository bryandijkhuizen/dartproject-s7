set check_function_bodies = off;
drop function if exists "public"."get_all_users"();

CREATE OR REPLACE FUNCTION public.get_all_users(name_filter text, role_filter text)
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
  AND ($2 IS NULL OR $2 = '' OR EXISTS (SELECT 1 FROM user_role ur JOIN role r ON ur.role_id = r.id WHERE ur.user_id = u.id AND r.name ILIKE '%' || $2 || '%'));
$function$
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


