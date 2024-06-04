create policy "Users can view posts"
on "public"."club_post"
as permissive
for select
to public
using (true);

create policy "Users can create new posts"
on "public"."club_post"
as permissive
for insert
to public
with check (true);

create policy "Users can edit posts"
on "public"."club_post"
as permissive
for update
to public
using (true);