CREATE OR REPLACE FUNCTION public.get_users_by_uuids(uuid_list uuid[])
 RETURNS SETOF "user"
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.user
    WHERE id = ANY(uuid_list);
END;
$function$
;