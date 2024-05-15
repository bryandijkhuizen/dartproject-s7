set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_avatar_url(user_id uuid)
 RETURNS text
 LANGUAGE plpgsql
AS $function$
DECLARE
    avatar_url TEXT;
BEGIN
    SELECT url INTO avatar_url
    FROM avatar
    WHERE id = (SELECT avatar_id FROM "user" WHERE id = user_id);
    
    RETURN avatar_url;
END;
$function$
;

create policy "Enable read access for all users"
on "public"."avatar"
as permissive
for select
to public
using (true);



