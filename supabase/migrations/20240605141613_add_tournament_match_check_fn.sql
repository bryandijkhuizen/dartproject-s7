-- create a function that checks if a match from "match" is also used in "tournament_match"
create or replace function is_tournament_match(match_id integer)
returns boolean as $$
  select exists(select 1 from tournament_match where match_id = $1);
$$ language sql;

-- create a policy that allows the functions to read the tournament_match table
create policy read_tournament_match on tournament_match for select using (true);
