enum PermissionList {
  createUser(permissionName: 'create_user'),
  updateUser(permissionName: 'update_user'),
  deleteUser(permissionName: 'delete_user'),
  playFriendlyMatch(permissionName: 'play_friendly_match'),
  createTournament(permissionName: 'create_tournament'),
  createClubTournament(permissionName: 'create_club_tournament'),
  updateTournament(permissionName: 'update_tournament'),
  updateClubTournament(permissionName: 'update_club_tournament'),
  deleteTournament(permissionName: 'delete_tournament'),
  deleteClubTournament(permissionName: 'delete_club_tournament'),
  joinTournament(permissionName: 'join_tournament'),
  markInTournament(permissionName: 'mark_in_tournament'),
  markInClubTournament(permissionName: 'mark_in_club_tournament'),
  createLeague(permissionName: 'create_league'),
  createClubLeague(permissionName: 'create_club_league'),
  deleteLeague(permissionName: 'delete_league'),
  deleteClubLeague(permissionName: 'delete_club_league'),
  joinLeague(permissionName: 'join_league'),
  markInLeague(permissionName: 'mark_in_league'),
  createClub(permissionName: 'create_club'),
  updateClub(permissionName: 'update_club'),
  deleteClub(permissionName: 'delete_club'),
  manageClubMembers(permissionName: 'manage_clubmembers'),
  createClubPost(permissionName: 'create_clubpost'),
  updateClubPost(permissionName: 'update_clubpost'),
  deleteClubPost(permissionName: 'delete_clubpost'),
  seeTournamentHistory(permissionName: 'see_tournament_history'),
  seeLeagueHistory(permissionName: 'see_league_history'),
  seeFriendlyMatchHistory(permissionName: 'see_friendly_match_history'),
  createRole(permissionName: 'create_role'),
  assignRole(permissionName: 'assign_role'),
  assignClubRole(permissionName: 'assign_clubrole');

  const PermissionList({required this.permissionName});

  final String permissionName;
}