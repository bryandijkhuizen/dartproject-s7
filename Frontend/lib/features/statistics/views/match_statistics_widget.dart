import 'package:darts_application/features/statistics/components/match.header.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/features/statistics/components/dropdown_selection.dart';
import 'package:darts_application/features/statistics/components/turn_row.dart';
import 'package:darts_application/features/statistics/controllers/statistics_data_controller.dart';
import 'package:darts_application/models/match_statistics.dart';
import 'package:darts_application/models/player_stats.dart';
import 'package:darts_application/models/turn.dart';

class MatchStatisticsWidget extends StatefulWidget {
  final int matchId;
  const MatchStatisticsWidget({super.key, required this.matchId});

  @override
  State<MatchStatisticsWidget> createState() => _MatchStatisticsWidgetState();
}

class _MatchStatisticsWidgetState extends State<MatchStatisticsWidget> {
  late Future<MatchStatisticsModel> _matchStatisticsFuture;
  int currentSet = 0;
  int currentLeg = 0;

  @override
  void initState() {
    super.initState();
    _matchStatisticsFuture = fetchMatchStatistics(widget.matchId);
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

        int currentSetId = matchStatistics.setIds[currentSet];
        final legData = matchStatistics.legDataBySet[currentSetId] ?? [];
        if (legData.isEmpty) {
          return const Center(
            child: Text('No legs available for the selected set.'),
          );
        }
        int currentLegId = legData[currentLeg]['id'];

        final player1Stats = PlayerStats(
          setsWon:
              matchStatistics.calculateSetsWon(matchStatistics.match.player1Id),
          legsWonInCurrentSet: matchStatistics.calculateLegsWon(
              currentSetId, matchStatistics.match.player1Id),
          averageScore: matchStatistics
              .calculateAverageScore(matchStatistics.match.player1Id),
          firstNineAverage: matchStatistics
              .calculateFirstNineAverage(matchStatistics.match.player1Id),
          averagePerDart: matchStatistics
              .calculateAveragePerDart(matchStatistics.match.player1Id),
          checkouts: matchStatistics
              .checkoutOutsVsAttempts(matchStatistics.match.player1Id),
        );

        final player2Stats = PlayerStats(
            setsWon: matchStatistics
                .calculateSetsWon(matchStatistics.match.player2Id),
            legsWonInCurrentSet: matchStatistics.calculateLegsWon(
                currentSetId, matchStatistics.match.player2Id),
            averageScore: matchStatistics
                .calculateAverageScore(matchStatistics.match.player2Id),
            firstNineAverage: matchStatistics
                .calculateFirstNineAverage(matchStatistics.match.player2Id),
            averagePerDart: matchStatistics
                .calculateAveragePerDart(matchStatistics.match.player2Id),
            checkouts: matchStatistics
                .checkoutOutsVsAttempts(matchStatistics.match.player2Id));

        List<TurnModel> filteredTurns = matchStatistics.turns
            .where((turn) => turn.legId == currentLegId)
            .toList();

        final turnRows = _buildTurnRows(filteredTurns, matchStatistics);

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
                  player1Average: player1Stats.averageScore,
                  player2Average: player2Stats.averageScore,
                  player1FirstNineAverage: player1Stats.firstNineAverage,
                  player2FirstNineAverage: player2Stats.firstNineAverage,
                  player1AveragePerDart: player1Stats.averagePerDart,
                  player2AveragePerDart: player2Stats.averagePerDart,
                  player1Checkouts: player1Stats.checkouts,
                  player2Checkouts: player2Stats.checkouts,
                  player1SetsWon: player1Stats.setsWon,
                  player2SetsWon: player2Stats.setsWon,
                  player1LegsWonInCurrentSet: player1Stats.legsWonInCurrentSet,
                  player2LegsWonInCurrentSet: player2Stats.legsWonInCurrentSet,
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

  List<Widget> _buildTurnRows(
      List<TurnModel> turns, MatchStatisticsModel matchStatistics) {
    if (turns.isEmpty) {
      return [
        const Center(
          child: Text('No turns available for this set and leg.'),
        ),
      ];
    }

    List<Widget> rows = [];

    int player1CurrentScore = matchStatistics.match.startingScore;
    int player2CurrentScore = matchStatistics.match.startingScore;

    rows.add(buildScoreRow(
      'Score',
      player1CurrentScore.toString(),
      '0',
      player2CurrentScore.toString(),
      'Score',
    ));

    String player1Id = matchStatistics.match.player1Id;
    String player2Id = matchStatistics.match.player2Id;

    List<TurnModel> player1Turns = turns
        .where((turn) => turn.playerId == player1Id)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));
    List<TurnModel> player2Turns = turns
        .where((turn) => turn.playerId == player2Id)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

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
