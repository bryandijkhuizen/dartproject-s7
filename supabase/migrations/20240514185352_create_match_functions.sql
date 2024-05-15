CREATE OR REPLACE FUNCTION get_match_by_id(match_id INT) RETURNS SETOF "match" AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM "match"
    WHERE id = match_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_players_by_match_id(match_id INT) 
RETURNS SETOF "user" AS
$$
BEGIN
    RETURN QUERY
    SELECT u.*
    FROM "user" u
    JOIN "match" m ON u.id = m.player1_id OR u.id = m.player2_id
    WHERE m.id = match_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_users()
RETURNS SETOF "user" AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM "user";
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_matches() 
RETURNS SETOF "match" AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM "match";
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION get_sets_by_match_id(current_match_id INT)
RETURNS SETOF "set" AS
$$
BEGIN
    RETURN QUERY
    SELECT *
    FROM "set"
    WHERE match_id = current_match_id;
END;
$$
LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION update_starting_player(current_match_id INT, player_id UUID)
RETURNS SETOF "match" AS
$$
BEGIN
    UPDATE "match"
    SET starting_player_id = player_id
    WHERE id = current_match_id;
    RETURN QUERY
    SELECT *
    FROM "match"
    WHERE id = current_match_id;
END;
$$
LANGUAGE plpgsql;
