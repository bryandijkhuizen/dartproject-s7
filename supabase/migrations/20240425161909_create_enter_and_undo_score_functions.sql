-- Procedure om een nieuwe set aan te maken
CREATE OR REPLACE FUNCTION public.create_set(match_id bigint)
RETURNS bigint LANGUAGE plpgsql AS $$
DECLARE
    new_set_id bigint;
BEGIN
    INSERT INTO set (match_id) VALUES (match_id) RETURNING id INTO new_set_id;
    RETURN new_set_id;
END;
$$;

-- Procedure om een nieuwe leg aan te maken
CREATE OR REPLACE FUNCTION public.create_leg(set_id bigint)
RETURNS bigint LANGUAGE plpgsql AS $$
DECLARE
    new_leg_id bigint;
BEGIN
    INSERT INTO leg (set_id) VALUES (set_id) RETURNING id INTO new_leg_id;
    RETURN new_leg_id;
END;
$$;

-- Procedure om een nieuwe beurt aan te maken
CREATE OR REPLACE FUNCTION public.create_turn(leg_id bigint, player_id uuid)
RETURNS bigint LANGUAGE plpgsql AS $$
DECLARE
    new_turn_id bigint;
BEGIN
    INSERT INTO turn (leg_id, player_id) VALUES (leg_id, player_id) RETURNING id INTO new_turn_id;
    RETURN new_turn_id;
END;
$$;

-- Procedure om een beurt bij te werken
CREATE OR REPLACE FUNCTION public.update_turn(turn_id bigint, score bigint, double_attempts int, double_hits int)
RETURNS void LANGUAGE plpgsql AS $$
BEGIN
    UPDATE turn SET score = score, double_attempts = double_attempts, double_hits = double_hits WHERE id = turn_id;
END;
$$;

-- Procedure om te controleren of een leg voltooid is en een nieuwe leg te starten
CREATE OR REPLACE FUNCTION public.check_leg_completion(leg_id bigint)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    remaining_score bigint;
BEGIN
    -- Bereken de resterende score voor deze leg
    SELECT SUM(score) INTO remaining_score FROM turn WHERE leg_id = leg_id;

    -- Controleer of de leg voltooid is
    IF remaining_score = 0 THEN
        -- Markeer de winnaar van de leg
        UPDATE leg SET winner_id = (SELECT player_id FROM turn WHERE leg_id = leg_id ORDER BY id ASC LIMIT 1) WHERE id = leg_id;
        
        -- Start een nieuwe leg als de set nog niet voltooid is
        PERFORM create_leg((SELECT set_id FROM leg WHERE id = leg_id));
    END IF;
END;
$$;

-- Procedure om een nieuwe leg en beurt te starten
CREATE OR REPLACE FUNCTION public.start_new_leg_and_turn(match_id bigint, player_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    current_set_id bigint;
    current_leg_id bigint;
    new_leg_id bigint;
    new_turn_id bigint;
BEGIN
    -- Vind de huidige set
    SELECT id INTO current_set_id FROM set WHERE match_id = match_id ORDER BY id DESC LIMIT 1;

    -- Maak een nieuwe leg aan als er nog geen is in de huidige set
    SELECT id INTO current_leg_id FROM leg WHERE set_id = current_set_id ORDER BY id DESC LIMIT 1;
    IF current_leg_id IS NULL THEN
        SELECT create_leg(current_set_id) INTO new_leg_id;
    ELSE
        new_leg_id := current_leg_id;
    END IF;

    -- Maak een nieuwe beurt aan voor de nieuwe leg
    SELECT create_turn(new_leg_id, player_id) INTO new_turn_id;
END;
$$;

-- Procedure om een score in te voeren en te controleren op voltooiing van een leg
CREATE OR REPLACE FUNCTION public.enter_score(leg_id bigint, player_id uuid, score bigint)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    current_score bigint;
BEGIN
    -- Voeg de score toe aan de beurten tabel
    INSERT INTO turn (leg_id, player_id, score) VALUES (leg_id, player_id, score);

    -- Bereken de resterende score
    SELECT SUM(score) INTO current_score FROM turn WHERE leg_id = leg_id AND player_id = player_id;

    -- Controleer of de speler de leg heeft gewonnen
    IF current_score = 0 THEN
        -- Markeer de winnaar in de legs tabel
        UPDATE leg SET winner_id = player_id WHERE id = leg_id;

        -- Controleer of deze overwinning een set voltooit
        PERFORM check_set_completion(leg_id);
    END IF;
END;
$$;

-- Procedure om te controleren of het voltooien van een leg een set voltooit
CREATE OR REPLACE FUNCTION public.check_set_completion(leg_id bigint)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    set_id bigint;
    leg_count bigint;
    winning_leg_count bigint;
BEGIN
    -- Zoek de set op waar deze leg bij hoort
    SELECT set_id INTO set_id FROM leg WHERE id = leg_id;

    -- Tel het aantal legs in deze set en hoeveel er door dezelfde speler zijn gewonnen
    SELECT COUNT(*), COUNT(*) FILTER (WHERE winner_id = (SELECT winner_id FROM leg WHERE id = leg_id))
    INTO leg_count, winning_leg_count
    FROM leg
    WHERE set_id = set_id;

    -- Controleer of de speler de set heeft gewonnen
    IF winning_leg_count * 2 > leg_count THEN  -- Meer dan de helft van de legs zijn gewonnen
        -- Markeer de winnaar in de sets tabel
        UPDATE set SET winner_id = (SELECT winner_id FROM leg WHERE id = leg_id) WHERE id = set_id;
    END IF;
END;
$$;

-- Procedure om de laatste score ongedaan te maken
CREATE OR REPLACE FUNCTION public.undo_last_score(leg_id bigint, player_id uuid)
RETURNS void LANGUAGE plpgsql AS $$
DECLARE
    last_turn_id bigint;
BEGIN
    -- Zoek de laatste beurt voor deze leg en speler
    SELECT id INTO last_turn_id FROM turn
    WHERE leg_id = leg_id AND player_id = player_id
    ORDER BY id DESC LIMIT 1;

    -- Verwijder de laatste beurt als deze bestaat
    IF last_turn_id IS NOT NULL THEN
        DELETE FROM turn WHERE id = last_turn_id;
    END IF;
END;
$$;

-- Stored procedure voor het ophalen van de huidige legstand
CREATE OR REPLACE FUNCTION public.get_current_leg_stand(match_id bigint)
RETURNS TABLE(winner_id uuid, count bigint) LANGUAGE sql STABLE AS $$
SELECT winner_id, COUNT(winner_id) FROM leg
WHERE match_id = $1
GROUP BY winner_id;
$$;

-- Stored procedure voor het ophalen van de huidige setstand
CREATE OR REPLACE FUNCTION public.get_current_set_stand(match_id bigint)
RETURNS TABLE(winner_id uuid, count bigint) LANGUAGE sql STABLE AS $$
SELECT winner_id, COUNT(winner_id) FROM set
WHERE match_id = $1
GROUP BY winner_id;
$$;

-- Stored procedure voor het ophalen van beurten voor een bepaalde match
CREATE OR REPLACE FUNCTION public.get_turns_for_match(input_match_id bigint)
RETURNS TABLE(turn_id bigint, player_id uuid, score bigint) AS $$
BEGIN
    RETURN QUERY
    SELECT t.id as turn_id, t.player_id, t.score
    FROM turn t
    JOIN leg l ON t.leg_id = l.id
    JOIN set s ON l.set_id = s.id
    WHERE s.match_id = input_match_id
    ORDER BY t.id DESC;
END;
$$ LANGUAGE plpgsql;

-- Stored procedure voor het ophalen van details van een match
CREATE OR REPLACE FUNCTION public.get_match_details(match_id bigint)
RETURNS TABLE(
    id bigint,
    player_1_name text,
    player_2_name text,
    starting_score bigint,
    starting_player_id uuid,
    set_target bigint,
    leg_target bigint
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        m.id,
        COALESCE(p1.last_name, 'Unknown') AS player_1_name,
        COALESCE(p2.last_name, 'Unknown') AS player_2_name,
        m.starting_score,
        m.starting_player_id,
        m.set_target,
        m.leg_target
    FROM
        "match" m
    LEFT JOIN
        "user" p1 ON m.player_1_id = p1.id
    LEFT JOIN
        "user" p2 ON m.player_2_id = p2.id
    WHERE
        m.id = match_id;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'No match found with id %', match_id;
    END IF;
END;
$$ LANGUAGE plpgsql;

-- Procedure om het eindresultaat van de wedstrijd op te halen
CREATE OR REPLACE FUNCTION public.get_end_of_match_result(match_id bigint)
RETURNS TABLE(
    winner_name text,
    loser_name text,
    set_stand text,
    leg_stand text
) AS $$
DECLARE
    winner_id uuid;
    player_1_name text;
    player_2_name text;
    winner_stand text;
    loser_stand text;
BEGIN
    -- Haal de details van de wedstrijd op
    SELECT
        winner_id,
        COALESCE(p1.last_name, 'Unknown'),
        COALESCE(p2.last_name, 'Unknown')
    INTO
        winner_id, player_1_name, player_2_name
    FROM
        "match" m
    LEFT JOIN
        "user" p1 ON m.player_1_id = p1.id
    LEFT JOIN
        "user" p2 ON m.player_2_id = p2.id
    WHERE
        m.id = match_id;

    -- Bepaal de naam van de winnaar en verliezer
    IF winner_id = m.player_1_id THEN
        winner_name := player_1_name;
        loser_name := player_2_name;
    ELSE
        winner_name := player_2_name;
        loser_name := player_1_name;
    END IF;

    -- Haal de huidige stand van de set op
    SELECT
        COALESCE(winner_count || '-' || loser_count, '0-0')
    INTO
        set_stand
    FROM (
        SELECT
            COUNT(*) FILTER (WHERE winner_id = winner_id) AS winner_count,
            COUNT(*) FILTER (WHERE winner_id <> winner_id) AS loser_count
        FROM
            set
        WHERE
            match_id = match_id
    ) AS subquery;

    -- Haal de huidige stand van de leg op als de wedstrijd op basis van legs wordt gespeeld
    IF (SELECT set_target FROM "match" WHERE id = match_id) = 1 THEN
        SELECT
            COALESCE(winner_count || '-' || loser_count, '0-0')
        INTO
            leg_stand
        FROM (
            SELECT
                COUNT(*) FILTER (WHERE winner_id = winner_id) AS winner_count,
                COUNT(*) FILTER (WHERE winner_id <> winner_id) AS loser_count
            FROM
                leg
            WHERE
                match_id = match_id
        ) AS subquery;
    ELSE
        leg_stand := NULL;
    END IF;

    RETURN NEXT;
END;
$$ LANGUAGE plpgsql;

