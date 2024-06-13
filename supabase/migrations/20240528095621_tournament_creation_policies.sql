create policy "Users can view tournaments"
on "public"."tournament"
as permissive
for select
to public
using (true);

create policy "Users can create new tournaments"
on "public"."tournament"
as permissive
for insert
to public
with check (true);
