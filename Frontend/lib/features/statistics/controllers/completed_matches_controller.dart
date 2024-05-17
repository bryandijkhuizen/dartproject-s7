import 'dart:async';
import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/features/statistics/controllers/statistics_data_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';

class CompletedMatchesController {
  final List<MatchModel> _matches = [];
  final List<PlayerModel> _players = [];
  bool _isLoading = false;
  bool _hasMore = true;

  final StreamController<List<MatchModel>> _matchesStreamController =
      StreamController.broadcast();

  Stream<List<MatchModel>> get matchesStream => _matchesStreamController.stream;
  bool get hasMore => _hasMore;

  void init() {
    _fetchPlayers().then((_) => fetchMatches());
  }

  Future<void> fetchMatches({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    if (refresh) {
      _hasMore = true;
      _matches.clear();
    }

    final response =
        await Supabase.instance.client.rpc('get_completed_matches');
    final newMatches =
        (response as List).map((json) => MatchModel.fromJson(json)).toList();

    if (newMatches.isNotEmpty) {
      _matches.addAll(newMatches);
    } else {
      _hasMore = false;
    }

    _matches.sort((a, b) => b.date.compareTo(a.date));

    _matchesStreamController.add(_matches);
    _isLoading = false;
  }

  Future<void> _fetchPlayers() async {
    final userResponse = await Supabase.instance.client.rpc('get_users');
    _players.addAll((userResponse as List)
        .map((json) => PlayerModel.fromJson(json))
        .toList());
  }

  String getPlayerName(String playerId) {
    final player = _players.firstWhere((player) => player.id == playerId);
    return player.lastName;
  }

  Future<String> getMatchResult(int matchId) async {
    final matchStatistics = await fetchMatchStatistics(matchId);
    final match = matchStatistics.match;
    final player1Id = match.player1Id;
    final player2Id = match.player2Id;

    if (match.setTarget > 1) {
      final player1SetsWon = matchStatistics.calculateSetsWon(player1Id);
      final player2SetsWon = matchStatistics.calculateSetsWon(player2Id);
      return '$player1SetsWon-$player2SetsWon';
    } else {
      final player1LegsWon = matchStatistics.calculateLegsWon(
          matchStatistics.setIds[0], player1Id);
      final player2LegsWon = matchStatistics.calculateLegsWon(
          matchStatistics.setIds[0], player2Id);
      return '$player1LegsWon-$player2LegsWon';
    }
  }

  void navigateToStatistics(String matchId) {
    router.push('/statistics/$matchId');
  }
}
