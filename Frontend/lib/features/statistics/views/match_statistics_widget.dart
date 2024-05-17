import 'package:darts_application/features/statistics/components/dropdown_selection.dart';
import 'package:darts_application/features/statistics/components/match.header.dart';
import 'package:darts_application/features/statistics/components/turn_row.dart';
import 'package:darts_application/models/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match_statistics.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/turn.dart';

class MatchStatisticsWidget extends StatefulWidget {
  final int matchId;
  const MatchStatisticsWidget({super.key, required this.matchId});

  @override
  State<MatchStatisticsWidget> createState() => _MatchStatisticsWidgetState();
}

class _MatchStatisticsWidgetState extends State<MatchStatisticsWidget> {
  late Future<MatchStatisticsModel> _matchStatisticsFuture;
  late int startingScore =
      501; // Assuming 501 as the starting score for both players

  late List<int> setIds = [];
  late Map<int, List<Map<String, dynamic>>> legDataBySet =
      {}; // Maps setId to list of leg data
  late List<TurnModel> turns = [];

  late String player1Id = "4d4026e9-f979-4055-962c-063b5a7d1997";
  late String player2Id = "13902fd6-2bca-4461-a68b-9d40eb026954";

  int currentSet = 0;
  int currentLeg = 0;

  @override
  void initState() {
    super.initState();
    _matchStatisticsFuture = fetchMatchStatistics(1);
  }

  Future<MatchStatisticsModel> fetchMatchStatistics(currentMatchId) async {
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
          final doubleHits = turn['double_hits'];
          final isDeadThrow = turn['is_dead_throw'];

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
            doubleHits: doubleHits as int? ?? 0,
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

  void _onSetChanged(int? newValue) {
    setState(() {
      currentSet = newValue ?? 0;
      currentLeg = 0; // Reset to the first leg when the set changes
    });
  }

  void _onLegChanged(int? newValue) {
    setState(() {
      currentLeg = newValue ?? 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MatchStatisticsModel>(
      future: _matchStatisticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load match statistics: ${snapshot.error}'),
          );
        }

        final matchStatistics = snapshot.data!;

        if (matchStatistics.setIds.isEmpty) {
          return const Center(
            child: Text('No sets available for this match.'),
          );
        }

        final player1Average = matchStatistics.calculateAverageScore(player1Id);
        final player2Average = matchStatistics.calculateAverageScore(player2Id);

        // Get current set ID and leg ID based on the current indices
        int currentSetId = matchStatistics.setIds[currentSet];
        if (matchStatistics.legDataBySet[currentSetId] == null ||
            matchStatistics.legDataBySet[currentSetId]!.isEmpty) {
          return const Center(
            child: Text('No legs available for the selected set.'),
          );
        }
        int currentLegId =
            matchStatistics.legDataBySet[currentSetId]![currentLeg]['id'];

        // Filter turns for the current set and leg
        List<TurnModel> filteredTurns = matchStatistics.turns
            .where((turn) => turn.legId == currentLegId)
            .toList();

        final turnRows = _buildTurnRows(filteredTurns);

        // Calculate legs and sets won
        int player1SetsWon = matchStatistics.calculateSetsWon(player1Id);
        int player2SetsWon = matchStatistics.calculateSetsWon(player2Id);
        int player1LegsWonInCurrentSet =
            matchStatistics.calculateLegsWon(currentSetId, player1Id);
        int player2LegsWonInCurrentSet =
            matchStatistics.calculateLegsWon(currentSetId, player2Id);

        return Scaffold(
          appBar: AppBar(
            title: const Text('Statistics'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  matchStatistics.match.setTarget > 1
                      ? 'First to ${matchStatistics.match.setTarget} sets'
                      : 'First to ${matchStatistics.match.legTarget} leg(s)',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  matchStatistics.match.date.toString().substring(0, 10),
                  style: const TextStyle(
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 16),
                MatchHeader(
                  matchStatistics: matchStatistics,
                  player1Average: player1Average,
                  player2Average: player2Average,
                  player1SetsWon: player1SetsWon,
                  player2SetsWon: player2SetsWon,
                  player1LegsWonInCurrentSet: player1LegsWonInCurrentSet,
                  player2LegsWonInCurrentSet: player2LegsWonInCurrentSet,
                ),
                const SizedBox(height: 16),
                DropdownSelection(
                  setIds: matchStatistics.setIds,
                  legDataBySet: matchStatistics.legDataBySet,
                  currentSet: currentSet,
                  currentLeg: currentLeg,
                  onSetChanged: _onSetChanged,
                  onLegChanged: _onLegChanged,
                ),
                const SizedBox(height: 24),
                const Divider(),
                Expanded(
                  child: ListView(
                    children: turnRows,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildTurnRows(List<TurnModel> turns) {
    if (turns.isEmpty) {
      return [
        const Center(
          child: Text('No turns available for this set and leg.'),
        ),
      ];
    }

    List<Widget> rows = [];

    // Initial scores
    int player1CurrentScore = startingScore;
    int player2CurrentScore = startingScore;

    // First display the current score of both players and the number of turn
    rows.add(buildScoreRow(
      'Score',
      player1CurrentScore.toString(),
      '0',
      player2CurrentScore.toString(),
      'Score',
    ));

    // Get all the turns for this leg and put them in 2 lists (one for each player)
    // Sort them by id and give them a turn number (1, 2, 3, ...)
    List<TurnModel> player1Turns = turns
        .where((turn) => turn.playerId == player1Id)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    List<TurnModel> player2Turns = turns
        .where((turn) => turn.playerId == player2Id)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    // Display the turns in the correct order
    int turnNumber = 1;
    for (int i = 0; i < player1Turns.length || i < player2Turns.length; i++) {
      String player1Score = '';
      String player2Score = '';
      bool isPlayer1WinningTurn = false;
      bool isPlayer2WinningTurn = false;

      if (i < player1Turns.length) {
        player1CurrentScore -= player1Turns[i].score;
        player1Score = player1Turns[i].score.toString();
        isPlayer1WinningTurn = player1CurrentScore == 0;
      }

      if (i < player2Turns.length) {
        player2CurrentScore -= player2Turns[i].score;
        player2Score = player2Turns[i].score.toString();
        isPlayer2WinningTurn = player2CurrentScore == 0;
      }

      rows.add(buildScoreRow(
        player1Score,
        player1CurrentScore.toString(),
        turnNumber.toString(),
        player2CurrentScore.toString(),
        player2Score,
        isPlayer1WinningTurn: isPlayer1WinningTurn,
        isPlayer2WinningTurn: isPlayer2WinningTurn,
      ));

      turnNumber++;
    }

    return rows;
  }

  Widget buildScoreRow(String score1, String remainingScore, String turnNumber,
      String remainingScore2, String score2,
      {bool isPlayer1WinningTurn = false, bool isPlayer2WinningTurn = false}) {
    return TurnRow(
      score1: score1,
      remainingScore: remainingScore,
      turnNumber: turnNumber,
      remainingScore2: remainingScore2,
      score2: score2,
      isPlayer1WinningTurn: isPlayer1WinningTurn,
      isPlayer2WinningTurn: isPlayer2WinningTurn,
    );
  }
}
