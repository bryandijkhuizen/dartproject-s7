create
or replace function public.is_user_member_of_club (p_user_id uuid, p_club_id bigint) returns boolean as $$
BEGIN
    RETURN EXISTS (
        SELECT 1
        FROM public.user_club
        WHERE user_id = p_user_id
        AND club_id = p_club_id
        AND approved = true
    );
END;
$$ language plpgsql;

create
or replace function public.add_user_to_club (p_user_id uuid, p_club_id bigint) returns void as $$
BEGIN
    INSERT INTO public.user_club (user_id, club_id, approved)
    VALUES (p_user_id, p_club_id, false);
END;
$$ language plpgsql;

create policy "Allow users to add entry to user_club" on "public"."user_club" as permissive for insert to public with check (true);