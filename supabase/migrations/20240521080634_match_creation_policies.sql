create policy "Users can view matches"
on "public"."match"
as permissive
for select
to public
using (true);

create policy "Users can create new matches"
on "public"."match"
as permissive
for insert
to public
using (true);

create policy "Users can edit matches"
on "public"."match"
as permissive
for update
to public
using (true);