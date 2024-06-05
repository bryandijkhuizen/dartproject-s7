set check_function_bodies = off;



CREATE OR REPLACE FUNCTION public.get_tournament_matches(current_tournament_id integer)
 RETURNS TABLE(match_id bigint, player_1_name text, player_2_name text, match_date timestamp with time zone, match_location text, round_number bigint)
 LANGUAGE plpgsql
AS $function$
BEGIN
    RETURN QUERY
    SELECT tm.match_id, 
           COALESCE(u1.first_name || ' ' || u1.last_name, 'To be decided') AS player_1_name, 
           COALESCE(u2.first_name || ' ' || u2.last_name, 'To be decided') AS player_2_name, 
           m.date AS match_date, 
           m.location AS match_location, 
           tm.round_number
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


create policy "Enable insert access for all users"
on "public"."tournament_match"
as permissive
for insert
to public
with check (true);


create policy "Enable read access for all users"
on "public"."tournament_match"
as permissive
for select
to public
using (true);



