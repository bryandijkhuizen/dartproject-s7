create policy "select_own_matches"
on public.match
as permissive
for select
using (
    true
);

create policy "update_own_matches"
on public.match
as permissive
for update
using (
    auth.uid() = player_1_id OR auth.uid() = player_2_id
);
