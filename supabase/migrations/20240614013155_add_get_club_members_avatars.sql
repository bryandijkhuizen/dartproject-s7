create function get_club_members_avatars (p_club_id bigint) returns table (full_name text, avatar_url text) as $$
select u.first_name || ' ' || u.last_name as full_name, a.url as avatar_url
from public.user_club uc
join public.user u on uc.user_id = u.id
join public.avatar a on u.avatar_id = a.id
where uc.club_id = club_id and uc.approved = true;
$$ language sql;