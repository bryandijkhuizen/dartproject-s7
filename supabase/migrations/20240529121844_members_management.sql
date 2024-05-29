set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.approve_user_from_club(current_user_id uuid, current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE user_club SET approved = true WHERE approved = false and user_id = current_user_id and club_id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_user_from_club(current_user_id uuid, current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  delete from user_club WHERE user_id = current_user_id AND club_id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_club_member_names_and_ids(current_club_id bigint)
 RETURNS TABLE(user_id uuid, first_name text)
 LANGUAGE plpgsql
AS $function$BEGIN
    RETURN QUERY
    SELECT u.id, u.first_name
    FROM public.user u
    JOIN public.user_club uc ON u.id = uc.user_id
    WHERE uc.club_id = current_club_id and uc.approved = true;
END;$function$
;

CREATE OR REPLACE FUNCTION public.get_not_approved_club_member_names_and_ids(current_club_id bigint)
 RETURNS TABLE(user_id uuid, first_name text)
 LANGUAGE plpgsql
AS $function$BEGIN
    RETURN QUERY
    SELECT u.id, u.first_name
    FROM public.user u
    JOIN public.user_club uc ON u.id = uc.user_id
    WHERE uc.club_id = current_club_id and uc.approved = false;
END;$function$
;

create policy "allow members admins to do all users from clubs"
on "public"."user_club"
as permissive
for all
to public
using ((auth.uid() IN ( SELECT user_club_role_1.user_id
   FROM user_club_role user_club_role_1
  WHERE (user_club_role_1.club_role_id IN ( SELECT user_club_role_2.club_role_id
           FROM ((user_club_role user_club_role_2
             JOIN club_role_permission ON ((user_club_role_2.club_role_id = club_role_permission.club_role_id)))
             JOIN permission ON ((club_role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'manage_clubmembers'::text))))));
