set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_all_users()
 RETURNS SETOF "user"
 LANGUAGE sql
AS $function$ select * from "user"; $function$
;


