CREATE OR REPLACE FUNCTION get_match_details(match_id uuid)
RETURNS TABLE(
    id uuid,
    player_1_name text,
    player_2_name text,
    starting_player_name text,
    winner_name text
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        p1.last_name as player_1_name,
        p2.last_name as player_2_name,
        sp.last_name as starting_player_name,
        w.last_name as winner_name
    FROM
        match m
    JOIN
        user p1 ON m.player_1_id = p1.id
    JOIN
        user p2 ON m.player_2_id = p2.id
    JOIN
        user sp ON m.starting_player_id = sp.id
    JOIN
        user w ON m.winner_id = w.id
    WHERE
        m.id = match_id;
END;
$$ LANGUAGE plpgsql;