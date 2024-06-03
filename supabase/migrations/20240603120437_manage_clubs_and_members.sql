alter table "public"."club" alter column "application_status" drop default;

create type "public"."Club application status" as enum ('Pending application', 'Approved', 'Rejected', 'Archived', 'Suspeneded');

alter table "public"."club" alter column application_status type "public"."Club application status" using application_status::text::"public"."Club application status";

alter table "public"."club" alter column "application_status" set default 'Pending application'::"Club application status";

alter table "public"."club" alter column "phone_number" drop default;

alter table "public"."club" alter column "phone_number" drop not null;

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.approve_club(current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE club SET application_status = 'Approved' WHERE id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.approve_user_from_club(current_user_id uuid, current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE user_club SET approved = true WHERE approved = false and user_id = current_user_id and club_id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.archive_club(current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  UPDATE club SET application_status = 'Archived' WHERE id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.delete_club_request(current_club_id integer)
 RETURNS void
 LANGUAGE plpgsql
AS $function$
BEGIN
  delete from club WHERE id = current_club_id;
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

CREATE OR REPLACE FUNCTION public.get_approved_clubs()
 RETURNS SETOF club
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.club
    WHERE application_status = 'Approved';
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_club_details(current_club_id integer)
 RETURNS TABLE(current_name text, current_address text, current_postalcode text, current_city text, current_email text, current_phonenumber text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT
        name,
        address,
        postal_code,
        city,
        email_address,
        phone_number
    FROM
        club
    WHERE
        id = current_club_id;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_club_member_names_and_ids(current_club_id bigint)
 RETURNS TABLE(user_id uuid, full_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT u.id, u.first_name || ' ' || u.last_name as full_name
    FROM public.user u
    JOIN public.user_club uc ON u.id = uc.user_id
    WHERE uc.club_id = current_club_id and uc.approved = true;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_not_approved_club_member_names_and_ids(current_club_id bigint)
 RETURNS TABLE(user_id uuid, full_name text)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT u.id, u.first_name || ' ' || u.last_name as full_name
    FROM public.user u
    JOIN public.user_club uc ON u.id = uc.user_id
    WHERE uc.club_id = current_club_id and uc.approved = false;
END;
$function$
;

CREATE OR REPLACE FUNCTION public.get_not_approved_clubs()
 RETURNS SETOF club
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT *
    FROM public.club
    WHERE application_status = 'Pending application';
END;
$function$
;

CREATE OR REPLACE FUNCTION public.update_club(p_id bigint, p_name text, p_address text, p_postal_code text, p_city text, p_email text, p_phone text)
 RETURNS result_type
 LANGUAGE plpgsql
AS $function$
DECLARE
    result result_type;
BEGIN
    BEGIN
        UPDATE club
        SET
            name = p_name,
            address = p_address,
            postal_code = p_postal_code,
            city = p_city,
            email_address = p_email,
            phone_number = p_phone
        WHERE id = p_id;

        result.success := TRUE;
        result.message := '';
    EXCEPTION
    WHEN foreign_key_violation THEN
        result.success := FALSE;
        result.message := 'A referenced entity does not exist.';
    WHEN check_violation THEN
        result.success := FALSE;
        result.message := 'A value fails a check constraint.';
    WHEN data_exception THEN
        result.success := FALSE;
        result.message := 'Invalid data format.';
    WHEN insufficient_privilege THEN
        result.success := FALSE;
        result.message := 'You do not have permission to perform this action.';
    WHEN others THEN
        result.success := FALSE;
        result.message := 'An error occurred. Please try again later.';
    END;
    
    RETURN result;
END;
$function$
;

create policy "allow club admins to edit a club"
on "public"."club"
as permissive
for update
to public
using ((auth.uid() IN ( SELECT user_club_role_1.user_id
   FROM user_club_role user_club_role_1
  WHERE (user_club_role_1.club_role_id IN ( SELECT user_club_role_2.club_role_id
           FROM ((user_club_role user_club_role_2
             JOIN club_role_permission ON ((user_club_role_2.club_role_id = club_role_permission.club_role_id)))
             JOIN permission ON ((club_role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'update_club'::text))))));


create policy "allow users with create club permission to approve clubs"
on "public"."club"
as permissive
for update
to public
using ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'create_club'::text))))));


create policy "allow users with delete club permission to delete clubs"
on "public"."club"
as permissive
for delete
to public
using ((auth.uid() IN ( SELECT ur.user_id
   FROM user_role ur
  WHERE (ur.role_id IN ( SELECT ur2.role_id
           FROM ((user_role ur2
             JOIN role_permission ON ((ur2.role_id = role_permission.role_id)))
             JOIN permission ON ((role_permission.permission_id = permission.id)))
          WHERE (permission.name = 'delete_club'::text))))));


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



