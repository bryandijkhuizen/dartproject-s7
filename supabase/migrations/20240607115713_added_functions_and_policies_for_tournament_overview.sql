set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.get_tournament_matches(current_tournament_id integer)
 RETURNS TABLE(id bigint, player_1_id uuid, player_1_last_name text, player_2_id uuid, player_2_last_name text, date timestamp with time zone, location text, round_number bigint, set_target bigint, leg_target bigint, starting_score bigint, winner_id uuid, starting_player_id uuid)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT tm.match_id, 
           m.player_1_id, 
           COALESCE(u1.last_name, 'To be decided') AS player_1_last_name, 
           m.player_2_id,
           COALESCE(u2.last_name, 'To be decided') AS player_2_last_name, 
           m.date AS match_date, 
           COALESCE(m.location, 'To be decided') AS match_location, 
           tm.round_number,
           m.set_target,
           m.leg_target,
           m.starting_score,
           m.winner_id,
           m.starting_player_id
    FROM tournament t
    JOIN tournament_match tm ON t.id = tm.tournament_id
    JOIN match m ON tm.match_id = m.id
    LEFT JOIN "user" u1 ON m.player_1_id = u1.id
    LEFT JOIN "user" u2 ON m.player_2_id = u2.id
    WHERE t.id = current_tournament_id
    ORDER BY tm.round_number;
END;
$function$
;

create policy "Enable read access for all users"
on "public"."tournament"
as permissive
for select
to public
using (true);

create policy "Enable read access for all users"
on "public"."tournament_match"
as permissive
for select
to public
using (true);



