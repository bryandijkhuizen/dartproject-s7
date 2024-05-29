import 'package:flutter/material.dart';

class PlayerStatisticsWidget extends StatelessWidget {
  final String playerName;
  final double average;
  final double firstNineAverage;
  final double averagePerDart;
  final String checkouts;

  const PlayerStatisticsWidget({
    super.key,
    required this.playerName,
    required this.average,
    required this.firstNineAverage,
    required this.averagePerDart,
    required this.checkouts,
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
        Text(
          'Checkouts: $checkouts',
          style: const TextStyle(
            fontSize: 14,
            color: Colors.white70,
          ),
        ),
      ],
    );
  }
}
