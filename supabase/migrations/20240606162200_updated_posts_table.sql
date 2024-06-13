alter table "public"."club_post" add column "created_at" timestamp with time zone not null default now();

alter table "public"."club_post" add column "updated_at" timestamp with time zone not null default now();

create policy "Anyone can see club posts"
on "public"."club_post"
as permissive
for select
to public
using (true);