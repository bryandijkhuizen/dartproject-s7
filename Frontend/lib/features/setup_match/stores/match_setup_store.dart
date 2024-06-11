import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'match_setup_store.g.dart';

class MatchSetupStore = _MatchSetupStore with _$MatchSetupStore;

abstract class _MatchSetupStore with Store {
  final SupabaseClient _supabase;
  final UserStore _userStore;

  _MatchSetupStore(this._supabase, this._userStore);

  @action
  Future<Map<String, List<MatchModel>>> fetchMatches() async {
    final matchResponsePending = await _supabase.rpc('get_pending_matches');
    final matchResponseActive = await _supabase.rpc('get_active_matches');

    matchResponsePending.removeWhere((match) =>
        match['player_1_id'] != _userStore.currentUser?.id &&
        match['player_2_id'] != _userStore.currentUser?.id);

    matchResponseActive.removeWhere((match) =>
        match['player_1_id'] != _userStore.currentUser?.id &&
        match['player_2_id'] != _userStore.currentUser?.id);

    matchResponsePending.removeWhere((match) => match['winner_id'] != null);
    matchResponseActive.removeWhere((match) => match['winner_id'] != null);

    final userResponse = await _supabase.rpc('get_users');
    List<PlayerModel> players = userResponse
        .map<PlayerModel>((user) => PlayerModel.fromJson(user))
        .toList();

    List<MatchModel> mapMatches(List<dynamic> matchResponse) {
      return matchResponse
          .map<MatchModel>((match) => MatchModel.fromJson(match))
          .map((match) {
        match.player1LastName = players
            .firstWhere((player) => player.id == match.player1Id)
            .lastName;
        match.player2LastName = players
            .firstWhere((player) => player.id == match.player2Id)
            .lastName;
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

  @action
  Future<bool> matchAlreadyStarted(matches, matchID) async {
    try {
      final response = await _supabase
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

  @action
  Future<void> updateStartingPlayer(playerId, matchId) async {
    await _supabase.rpc('update_starting_player',
        params: {'current_match_id': matchId, 'player_id': playerId});
  }

  @action
  void redirectToGameplay(matchId) {
    router.push('/matches/$matchId/gameplay/');
  }
}
