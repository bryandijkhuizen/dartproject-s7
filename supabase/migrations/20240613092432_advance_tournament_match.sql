CREATE OR REPLACE FUNCTION advance_tournament_match(p_match_id INTEGER)
RETURNS VOID AS $$
DECLARE
    v_tournament_id BIGINT;
    v_current_round_number BIGINT;
    v_next_round_number BIGINT;
    v_winner_id UUID;
    v_match_pair_number BIGINT;
    v_existing_match_id BIGINT;
    v_new_match_id BIGINT;
    v_player_1_id UUID;
    v_player_2_id UUID;
BEGIN
    -- Check if the match is a tournament match
    SELECT tm.tournament_id, tm.round_number, m.winner_id
    INTO v_tournament_id, v_current_round_number, v_winner_id
    FROM public.tournament_match tm
    JOIN public.match m ON tm.match_id = m.id
    WHERE tm.match_id = p_match_id;

    -- If no match found, raise an exception
    IF NOT FOUND THEN
        RAISE EXCEPTION 'Match ID % is not part of any tournament', p_match_id;
    END IF;

    -- Ensure the match has a winner
    IF v_winner_id IS NULL THEN
        RAISE EXCEPTION 'Match ID % has no winner yet', p_match_id;
    END IF;

    -- Determine the next round number
    v_next_round_number := v_current_round_number + 1;

    -- Determine the match pair number by counting how many matches have been played in the current round
    v_match_pair_number := (SELECT COUNT(*)
                            FROM public.tournament_match tm
                            JOIN public.match m ON tm.match_id = m.id
                            WHERE tm.tournament_id = v_tournament_id
                            AND tm.round_number = v_current_round_number
                            AND m.winner_id IS NOT NULL) + 1;

    -- Check if a match already exists for the next round in the tournament
    SELECT tm.match_id, m.player_1_id, m.player_2_id
    INTO v_existing_match_id, v_player_1_id, v_player_2_id
    FROM public.tournament_match tm
    JOIN public.match m ON tm.match_id = m.id
    WHERE tm.tournament_id = v_tournament_id
    AND tm.round_number = v_next_round_number
    LIMIT 1;

    -- If a match exists, update the existing match
    IF FOUND THEN
        IF v_player_1_id IS NULL OR v_player_1_id = v_winner_id THEN
            UPDATE public.match
            SET player_1_id = v_winner_id
            WHERE id = v_existing_match_id;
        ELSIF v_player_2_id IS NULL OR v_player_2_id = v_winner_id THEN
            UPDATE public.match
            SET player_2_id = v_winner_id
            WHERE id = v_existing_match_id;
        ELSE
            RAISE EXCEPTION 'Both player slots in match ID % are occupied', v_existing_match_id;
        END IF;
        
        -- Notify about the player advancement
        RAISE NOTICE 'Winner advanced to existing match ID % in round %', v_existing_match_id, v_next_round_number;

    -- If no match exists, throw exception because it was the final match assuming that in a tournament there is always a next match
    ELSE
        RAISE EXCEPTION 'No match found for round % in tournament ID %, this was the final', v_next_round_number, v_tournament_id;
    END IF;

END;
$$ LANGUAGE plpgsql;

-- Add a policy to insert into tournament_match table
CREATE POLICY insert_tournament_match ON tournament_match
    FOR INSERT
    WITH CHECK (true);

-- Add a policy to update the match table
CREATE POLICY update_match ON match
    FOR UPDATE
    USING (true);

-- Add a policy to update the tournament_match table
CREATE POLICY update_tournament_match ON tournament_match
    FOR UPDATE
    USING (true);
