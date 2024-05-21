CREATE OR REPLACE FUNCTION get_club_members(p_user_id UUID)
RETURNS SETOF JSON
LANGUAGE sql
AS $$
  SELECT row_to_json(record)
  FROM (
    SELECT u.id AS user_id, u.last_name, c.id AS club_id, c.name AS club_name
    FROM user_club uc
    JOIN club c ON uc.club_id = c.id
    JOIN "user" u ON uc.user_id = u.id
    WHERE uc.club_id = (
      SELECT club_id
      FROM user_club
      WHERE user_id = p_user_id
      LIMIT 1
    )
  ) AS record;
$$;
