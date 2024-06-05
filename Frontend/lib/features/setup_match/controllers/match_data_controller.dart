import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

UserStore userStore = UserStore(Supabase.instance.client);

Future<Map<String, List<MatchModel>>> fetchMatches() async {
  final matchResponsePending =
      await Supabase.instance.client.rpc('get_pending_matches');
  final matchResponseActive =
      await Supabase.instance.client.rpc('get_active_matches');

  matchResponsePending.removeWhere((match) =>
      match['player_1_id'] != userStore.currentUser?.id &&
      match['player_2_id'] != userStore.currentUser?.id);

  matchResponseActive.removeWhere((match) =>
      match['player_1_id'] != userStore.currentUser?.id &&
      match['player_2_id'] != userStore.currentUser?.id);

  matchResponsePending.removeWhere((match) => match['winner_id'] != null);
  matchResponseActive.removeWhere((match) => match['winner_id'] != null);

  final userResponse = await Supabase.instance.client.rpc('get_users');
  List<PlayerModel> players = userResponse
      .map<PlayerModel>((user) => PlayerModel.fromJson(user))
      .toList();

  List<MatchModel> mapMatches(List<dynamic> matchResponse) {
    return matchResponse
        .map<MatchModel>((match) => MatchModel.fromJson(match))
        .map((match) {
      match.player1LastName =
          players.firstWhere((player) => player.id == match.player1Id).lastName;
      match.player2LastName =
          players.firstWhere((player) => player.id == match.player2Id).lastName;
      return match;
    }).toList();
  }

  final pendingMatches = mapMatches(matchResponsePending);
  final activeMatches = mapMatches(matchResponseActive);

  return {
    'pending_matches': pendingMatches,
    'active_matches': activeMatches,
  };
}

Future<bool> matchAlreadyStarted(matches, matchID) async {
  try {
    final response = await Supabase.instance.client
        .rpc('get_sets_by_match_id', params: {'current_match_id': matchID});

    final match = matches.where((match) => match.id == matchID).first;

    if (response.length > 0 && match.startingPlayerId != null) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    throw Exception('Failed to check if match already started: $e');
  }
}

Future<void> updateStartingPlayer(playerId, matchId) async {
  await Supabase.instance.client.rpc('update_starting_player',
      params: {'current_match_id': matchId, 'player_id': playerId});
}

void redirectToGameplay(matchId) {
  router.push('/gameplay/$matchId');
}
