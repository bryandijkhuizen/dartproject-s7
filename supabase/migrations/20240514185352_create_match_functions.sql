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
