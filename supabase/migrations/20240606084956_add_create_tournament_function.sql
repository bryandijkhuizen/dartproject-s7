create
or replace function create_tournament (
  p_name text,
  p_location text,
  p_start_time timestamp with time zone,
  p_starting_method public.starter_method
) returns bigint language plpgsql as $$
DECLARE
    new_id bigint;
BEGIN
    INSERT INTO tournament (
        name,
        location,
        start_time,
        club_id,
        starting_method
    ) VALUES (
        p_name,
        p_location,
        p_start_time,
        NULL,
        p_starting_method
    ) RETURNING id INTO new_id;

    RETURN new_id;
EXCEPTION
    WHEN unique_violation THEN
        RAISE EXCEPTION 'A tournament with this information already exists.';
    WHEN foreign_key_violation THEN
        RAISE EXCEPTION 'A referenced entity does not exist.';
    WHEN check_violation THEN
        RAISE EXCEPTION 'A value fails a check constraint.';
    WHEN data_exception THEN
        RAISE EXCEPTION 'Invalid data format.';
    WHEN insufficient_privilege THEN
        RAISE EXCEPTION 'You do not have permission to perform this action.';
    WHEN others THEN
        RAISE EXCEPTION 'An error occurred. Please try again later.';
END;
$$;