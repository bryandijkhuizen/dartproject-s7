alter table "public"."club" alter column "banner_image_url" set default '''https://uasfeuipbeokslhkvtmq.supabase.co/storage/v1/object/public/club_banners/defaultbanner.png''::text'::text;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_user_clubs(p_user_id uuid)
 RETURNS SETOF club
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT c.*
    FROM club c
    INNER JOIN user_club uc ON c.id = uc.club_id
    WHERE uc.user_id = p_user_id;
END;
$function$
;

create policy "Clubs are publicly visible"
on "public"."club"
as permissive
for select
to public
using (true);


create policy "Clubs can only be deleted by the owner"
on "public"."club"
as permissive
for delete
to authenticated
using ((owner_id = auth.uid()));


create policy "Updates can only be done by the Owner"
on "public"."club"
as permissive
for update
to authenticated
using ((owner_id = auth.uid()));


create policy "Club members are publicly visible"
on "public"."user_club"
as permissive
for select
to public
using (true);



