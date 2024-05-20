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
          ),
        ],
      ),
    );
  }
}

class PlayerStatisticsWidget extends StatelessWidget {
  final String playerName;
  final double average;
  final double firstNineAverage;
  final double averagePerDart;

  const PlayerStatisticsWidget({
    super.key,
    required this.playerName,
    required this.average,
    required this.firstNineAverage,
    required this.averagePerDart,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          playerName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          average.toString(),
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          'First 9: ${firstNineAverage.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
        Text(
          'Per Dart: ${averagePerDart.toStringAsFixed(2)}',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
