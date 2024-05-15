alter table "public"."turn" drop constraint "public_turn_leg_id_fkey";

alter table "public"."leg" add constraint "public_leg_set_id_fkey" FOREIGN KEY (set_id) REFERENCES set(id) not valid;

alter table "public"."leg" validate constraint "public_leg_set_id_fkey";