insert into
  permission (name, description, scope)
values
  (
    'create_user',
    'Permission to create a user',
    'global'
  ),
  (
    'update_user',
    'Permission to update a user',
    'global'
  ),
  (
    'delete_user',
    'Permission to delete a user',
    'global'
  ),
  (
    'play_friendly_match',
    'Permission to play a friendly match',
    'global'
  ),
  (
    'create_tournament',
    'Permission to create a tournament',
    'global'
  ),
  (
    'create_club_tournament',
    'Permission to create a tournament with only club members',
    'club'
  ),
  (
    'update_tournament',
    'Permission to update a tournament',
    'global'
  ),
  (
    'update_club_tournament',
    'Permission to update a tournament with only club members',
    'club'
  ),
  (
    'delete_tournament',
    'Permission to delete a tournament',
    'global'
  ),
  (
    'delete_club_tournament',
    'Permission to delete a tournament with only club members',
    'club'
  ),
  (
    'join_tournament',
    'Permission to join a tournament',
    'global'
  ),
  (
    'mark_in_tournament',
    'Permission to mark in a tournament',
    'global'
  ),
  (
    'mark_in_club_tournament',
    'Permission to mark in a tournament',
    'club'
  ),
  (
    'create_league',
    'Permission to create a league',
    'global'
  ),
  (
    'create_club_league',
    'Permission to create a league for club members',
    'club'
  ),
  (
    'delete_league',
    'Permission to delete a league',
    'global'
  ),
  (
    'delete_club_league',
    'Permission to delete a league for club members',
    'club'
  ),
  (
    'join_league',
    'Permission to join a league',
    'global'
  ),
  (
    'mark_in_league',
    'Permission to mark in a league',
    'global'
  ),
  (
    'create_club',
    'Permission to create a club',
    'global'
  ),
  (
    'update_club',
    'Permission to update a club',
    'club'
  ),
  (
    'delete_club',
    'Permission to delete a club',
    'global'
  ),
  (
    'manage_clubmembers',
    'Permission to manage club members',
    'club'
  ),
  (
    'create_clubpost',
    'Permission to create a club post',
    'club'
  ),
  (
    'update_clubpost',
    'Permission to update a club post',
    'club'
  ),
  (
    'delete_clubpost',
    'Permission to delete a club post',
    'club'
  ),
  (
    'see_tournament_history',
    'Permission to see tournament history',
    'global'
  ),
  (
    'see_league_history',
    'Permission to see league history',
    'global'
  ),
  (
    'see_friendly_match_history',
    'Permission to see friendly match history',
    'global'
  ),
  (
    'create_rol',
    'Permission to create a role',
    'global'
  ),
  (
    'assign_rol',
    'Permission to assign a role',
    'global'
  ),
  (
    'assign_clubrol',
    'Permission to assign a club role',
    'club'
  );
