-- add player uuid to match
ALTER TABLE match ADD COLUMN starting_player_id UUID;
ALTER TABLE ONLY "public"."match"
    ADD CONSTRAINT "public_match_starting_player_id_fkey" FOREIGN KEY ("starting_player_id") REFERENCES "public"."user"("id") ON UPDATE CASCADE ON DELETE SET NULL