import 'package:darts_application/features/statistics/components/player_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match_statistics.dart';

class MatchHeader extends StatelessWidget {
  final MatchStatisticsModel matchStatistics;
  final double player1Average;
  final double player2Average;
  final double player1FirstNineAverage;
  final double player2FirstNineAverage;
  final double player1AveragePerDart;
  final double player2AveragePerDart;
  final String player1Checkouts;
  final String player2Checkouts;
  final int player1SetsWon;
  final int player2SetsWon;
  final int player1LegsWonInCurrentSet;
  final int player2LegsWonInCurrentSet;

  const MatchHeader({
    super.key,
    required this.matchStatistics,
    required this.player1Average,
    required this.player2Average,
    required this.player1FirstNineAverage,
    required this.player2FirstNineAverage,
    required this.player1AveragePerDart,
    required this.player2AveragePerDart,
    required this.player1Checkouts,
    required this.player2Checkouts,
    required this.player1SetsWon,
    required this.player2SetsWon,
    required this.player1LegsWonInCurrentSet,
    required this.player2LegsWonInCurrentSet,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 5,
            blurRadius: 7,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          PlayerStatisticsWidget(
            playerName: matchStatistics.match.player1LastName,
            average: player1Average,
            firstNineAverage: player1FirstNineAverage,
            averagePerDart: player1AveragePerDart,
            checkouts: player1Checkouts,
          ),
          Text(
            matchStatistics.match.setTarget > 1
                ? '$player1SetsWon-$player2SetsWon'
                : '$player1LegsWonInCurrentSet-$player2LegsWonInCurrentSet',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.yellow,
            ),
          ),
          PlayerStatisticsWidget(
            playerName: matchStatistics.match.player2LastName,
            average: player2Average,
            firstNineAverage: player2FirstNineAverage,
            averagePerDart: player2AveragePerDart,
            checkouts: player2Checkouts,
          ),
        ],
      ),
    );
  }
}
