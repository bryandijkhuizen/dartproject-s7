-- Beleidsregels voor 'match' tabel
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

-- Beleidsregels voor 'leg' tabel
CREATE POLICY "select_all_legs"
ON public.leg
AS PERMISSIVE
FOR SELECT
USING (true);

CREATE POLICY "update_legs_by_players"
ON public.leg
AS PERMISSIVE
FOR UPDATE
USING (EXISTS (SELECT 1 FROM public.match WHERE match.id = leg.set_id AND (match.player_1_id = auth.uid() OR match.player_2_id = auth.uid())));

-- Beleidsregels voor 'turn' tabel
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

-- Beleidsregels voor 'user' tabel
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
