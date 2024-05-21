drop policy "Enable read access for all users" on "public"."avatar";

drop policy "Clubs are publicly visible" on "public"."club";

drop policy "Clubs can only be deleted by the owner" on "public"."club";

drop policy "Updates can only be done by the Owner" on "public"."club";

drop policy "Users can create new matches" on "public"."match";

drop policy "Users can edit matches" on "public"."match";

drop policy "Users can view matches" on "public"."match";

drop policy "select_all_matches" on "public"."match";

drop policy "update_own_matches" on "public"."match";

drop policy "insert_own_user_row" on "public"."user";

drop policy "update_own_user_policy" on "public"."user";

drop policy "user_table_is_publicly_accessible" on "public"."user";

drop policy "Club members are publicly visible" on "public"."user_club";

alter table "public"."match" drop constraint "public_match_starting_player_id_fkey";

drop function if exists "public"."create_new_player"();

drop function if exists "public"."get_club_members"(p_user_id uuid);

drop function if exists "public"."get_user_avatar_url"(user_id uuid);

drop function if exists "public"."get_user_clubs"(p_user_id uuid);

drop function if exists "public"."update_public_user"();

alter table "public"."club" drop column "application_status";

alter table "public"."club" drop column "note";

alter table "public"."club" alter column "banner_image_url" set default 'https://uasfeuipbeokslhkvtmq.supabase.co/storage/v1/object/public/club_banners/defaultbanner.svg'::text;

alter table "public"."match" drop column "starting_player_id";

alter table "public"."tournament" drop column "starting_method";

alter table "public"."turn" add column "is_dead_throw" boolean;

drop type "public"."Club application status";

drop type "public"."starter_method";


