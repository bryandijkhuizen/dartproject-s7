import 'package:flutter/material.dart';
import 'package:darts_application/models/match_statistics.dart';

class MatchHeader extends StatelessWidget {
  final MatchStatisticsModel matchStatistics;
  final double player1Average;
  final double player2Average;
  final int player1SetsWon;
  final int player2SetsWon;
  final int player1LegsWonInCurrentSet;
  final int player2LegsWonInCurrentSet;

  const MatchHeader({
    super.key,
    required this.matchStatistics,
    required this.player1Average,
    required this.player2Average,
    required this.player1SetsWon,
    required this.player2SetsWon,
    required this.player1LegsWonInCurrentSet,
    required this.player2LegsWonInCurrentSet,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Column(
          children: [
            Text(
              matchStatistics.match.player1LastName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              player1Average.toString(),
              style: const TextStyle(
                fontSize: 36,
              ),
            ),
          ],
        ),
        Text(
          matchStatistics.match.setTarget > 1
              ? '$player1SetsWon-$player2SetsWon'
              : '$player1LegsWonInCurrentSet-$player2LegsWonInCurrentSet',
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.yellow, // Set this to yellow
          ),
        ),
        Column(
          children: [
            Text(
              matchStatistics.match.player2LastName,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              player2Average.toString(),
              style: const TextStyle(
                fontSize: 36,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
