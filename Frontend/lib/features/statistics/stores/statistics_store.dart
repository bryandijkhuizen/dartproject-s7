import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/match_statistics.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/models/turn.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:async';

part 'statistics_store.g.dart';

class StatisticsStore = _StatisticsStore with _$StatisticsStore;

abstract class _StatisticsStore with Store {
  final SupabaseClient _supabase;
  final UserStore _userStore;

  @observable
  ObservableList<MatchModel> _matches = ObservableList<MatchModel>();

  @observable
  ObservableList<PlayerModel> _players = ObservableList<PlayerModel>();

  @observable
  bool _isLoading = false;

  @observable
  bool _hasMore = true;

  final StreamController<List<MatchModel>> _matchesStreamController =
      StreamController.broadcast();

  Stream<List<MatchModel>> get matchesStream => _matchesStreamController.stream;
  bool get hasMore => _hasMore;

  _StatisticsStore(this._supabase, this._userStore);

  @action
  void init() {
    _fetchPlayers().then((_) => fetchMatches());
  }

  @action
  Future<void> fetchMatches({bool refresh = false}) async {
    if (_isLoading) return;
    _isLoading = true;

    if (refresh) {
      _matches.clear();
      _matchesStreamController.add([]);
      _hasMore = true;
    }

    final response =
        await Supabase.instance.client.rpc('get_completed_matches');

    response.removeWhere((match) =>
        match['player_1_id'] != _userStore.currentUser?.id &&
        match['player_2_id'] != _userStore.currentUser?.id);

    final newMatches =
        (response as List).map((json) => MatchModel.fromJson(json)).toList();

    if (newMatches.isNotEmpty) {
      _matches.addAll(newMatches.where((newMatch) =>
          !_matches.any((existingMatch) => existingMatch.id == newMatch.id)));
    } else {
      _hasMore = false;
    }

    _matches.sort((a, b) => b.date.compareTo(a.date));

    _matchesStreamController.add(List<MatchModel>.from(_matches));
    _isLoading = false;
  }

  @action
  Future<void> _fetchPlayers() async {
    final userResponse = await Supabase.instance.client.rpc('get_users');
    _players.addAll((userResponse as List)
        .map((json) => PlayerModel.fromJson(json))
        .toList());
  }

  @action
  String getPlayerName(String playerId) {
    try {
      final player = _players.firstWhere((player) => player.id == playerId);
      return player.lastName;
    } catch (e) {
      return 'Unknown Player';
    }
  }

  @action
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

  @action
  void navigateToStatistics(String matchId) {
    router.push('/statistics/$matchId');
  }

  @action
  Future<MatchStatisticsModel> fetchMatchStatistics(int currentMatchId) async {
    final client = Supabase.instance.client;

    final matchResponse = await client.rpc('get_completed_match_by_id',
        params: {'match_id': currentMatchId}).single();

    final setsResponse = await client.rpc('get_sets_by_match_id',
        params: {'current_match_id': currentMatchId});

    final setsData = setsResponse as List<dynamic>? ?? [];
    final setIds = setsData.map<int>((set) => set['id'] as int).toList();

    final legDataBySet = <int, List<Map<String, dynamic>>>{};

    for (final setId in setIds) {
      final legsResponse = await client
          .rpc('get_legs_by_set_id', params: {'current_set_id': setId});

      final legsData = legsResponse as List<dynamic>? ?? [];

      legDataBySet[setId] = legsData
          .map((leg) => {
                'id': leg['id'] as int,
                'winner_id': leg['winner_id'] as String,
              })
          .toList();
    }

    final turns = await Future.wait(setIds.expand((setId) {
      return legDataBySet[setId]!.map((leg) async {
        final legId = leg['id'];
        final turnsResponse = await client
            .rpc('get_turns_by_leg_id', params: {'current_leg_id': legId});

        return (turnsResponse as List<dynamic>? ?? []).map((turn) {
          // Ensure turn fields are not null and handle them properly
          final id = turn['id'];
          final playerId = turn['player_id'];
          final legId = turn['leg_id'];
          final score = turn['score'];
          final doubleAttempts = turn['double_attempts'];
          final doubleHit = turn['double_hit'];
          final isDeadThrow = turn['is_dead_throw'];
          final dartsForCheckout = turn['darts_for_checkout'];

          if (id == null ||
              playerId == null ||
              legId == null ||
              score == null ||
              isDeadThrow == null) {
            throw Exception('Invalid turn data');
          }

          return TurnModel(
            id: id as int,
            playerId: playerId as String,
            legId: legId as int,
            score: score as int,
            doubleAttempts: doubleAttempts as int? ?? 0,
            doubleHit: doubleHit as bool? ?? false,
            dartsForCheckout: dartsForCheckout as int? ?? 0,
            isDeadThrow: isDeadThrow as bool,
          );
        }).toList();
      });
    }).toList())
        .then((turnLists) => turnLists.expand((turnList) => turnList).toList());

    final userResponse = await Supabase.instance.client.rpc('get_users');

    if (userResponse == null) {
      throw Exception('Failed to load users');
    }

    final players = userResponse
        .map<PlayerModel>((user) => PlayerModel.fromJson(user))
        .toList();

    final match = MatchModel.fromJson(matchResponse);

    match.player1LastName =
        players.firstWhere((player) => player.id == match.player1Id).lastName;
    match.player2LastName =
        players.firstWhere((player) => player.id == match.player2Id).lastName;

    return MatchStatisticsModel(
      turns: turns,
      match: match,
      legDataBySet: legDataBySet,
      setIds: setIds,
    );
  }

  @action
  Future<String> calculateFinalScore(int matchId) async {
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

  @action
  List<FlSpot> convertAveragesToInts(List<FlSpot> averages) {
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // convert to int, round to have 0 decimal places and return a new list of FlSpot objects
    return averages
        .map((average) => FlSpot(average.x, average.y.roundToDouble()))
        .toList();
  }

  @action
  List<FlSpot> findLowestAverage(player1SetAverages, player2SetAverages) {
    double player1Average =
        player1SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player1SetAverages.length;
    double player2Average =
        player2SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player2SetAverages.length;
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // we want to convert the y value to an int and return a new list of FlSpot objects

    if (player1Average < player2Average) {
      return convertAveragesToInts(player1SetAverages);
    } else {
      return convertAveragesToInts(player2SetAverages);
    }
  }

  @action
  List<FlSpot> findHighestAverage(player1SetAverages, player2SetAverages) {
    double player1Average =
        player1SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player1SetAverages.length;
    double player2Average =
        player2SetAverages.map((average) => average.y).reduce((a, b) => a + b) /
            player2SetAverages.length;
    // every valuble in the list is a FlSpot object and that contains a x and y value
    // we want to convert the y value to an int and return a new list of FlSpot objects

    if (player1Average > player2Average) {
      return convertAveragesToInts(player1SetAverages);
    } else {
      return convertAveragesToInts(player2SetAverages);
    }
  }

  @action
  List<FlSpot> getSetAverages(
      MatchStatisticsModel matchStatistics, String playerId) {
    List<FlSpot> spots = [];
    for (int i = 0; i < matchStatistics.setIds.length; i++) {
      double average = matchStatistics.calculateSetAverage(
          playerId, matchStatistics.setIds[i]);
      spots.add(FlSpot(i.toDouble(), average));
    }
    return spots;
  }

  @action
  List<FlSpot> getLegAverages(
      MatchStatisticsModel matchStatistics, String playerId) {
    List<FlSpot> spots = [];
    for (int i = 0;
        i < matchStatistics.legDataBySet[matchStatistics.setIds[0]]!.length;
        i++) {
      double average = matchStatistics.calculateLegAverage(playerId,
          matchStatistics.legDataBySet[matchStatistics.setIds[0]]![i]['id']);
      spots.add(FlSpot(i.toDouble(), average));
    }
    return spots;
  }
}
