drop function if exists "public"."get_current_user_roles"(current_user_id uuid);

set check_function_bodies = off;

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



