-- Policies for 'match' table
CREATE POLICY "select_all_matches"
ON public.match
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_own_matches"
ON public.match
AS PERMISSIVE
FOR UPDATE
USING (auth.uid() = player_1_id OR auth.uid() = player_2_id);

-- Policies for 'leg' table
CREATE POLICY "select_all_legs"
ON public.leg
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_legs_by_players"
ON public.leg
AS PERMISSIVE
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.match 
        JOIN public.set ON match.id = set.match_id 
        WHERE set.id = leg.set_id 
        AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())
    )
);

CREATE POLICY "create_leg_by_players"
ON public.leg
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.set
        JOIN public.match ON match.id = set.match_id
        WHERE set.id = leg.set_id 
        AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())
    )
);

-- Policies for 'turn' table
CREATE POLICY "select_all_turns"
ON public.turn
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_own_turns"
ON public.turn
AS PERMISSIVE
FOR UPDATE
USING (auth.uid() = player_id);

CREATE POLICY "create_turn_by_players"
ON public.turn
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.leg
        JOIN public.set ON set.id = leg.set_id
        JOIN public.match ON match.id = set.match_id
        WHERE leg.id = turn.leg_id 
        AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())
    )
);

-- Policies for 'user' table
CREATE POLICY "select_users"
ON public.user
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_own_user"
ON public.user
AS PERMISSIVE
FOR UPDATE
USING (auth.uid() = id);

-- Policies for 'set' table
CREATE POLICY "select_all_sets"
ON public.set
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_sets_by_players"
ON public.set
AS PERMISSIVE
FOR UPDATE
USING (
    EXISTS (
        SELECT 1 FROM public.match 
        WHERE match.id = set.match_id 
        AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())
    )
);

CREATE POLICY "create_set_by_players"
ON public.set
AS PERMISSIVE
FOR INSERT
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.match 
        WHERE match.id = set.match_id 
        AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())
    )
);
