import 'package:darts_application/features/statistics/controllers/completed_matches_controller.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;
  final CompletedMatchesController controller;

  const MatchCard({required this.match, required this.controller, super.key});

  @override
  Widget build(BuildContext context) {
    final matchId = int.parse(match.id);
    return FutureBuilder<String>(
      future: controller.getMatchResult(matchId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {
          return Center(
              child: Text('Failed to load result: ${snapshot.error}'));
        }

        final finalResult = snapshot.data ?? 'N/A';

        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${controller.getPlayerName(match.player1Id)} vs ${controller.getPlayerName(match.player2Id)}',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 5),
                Text(
                  'Date: ${match.date.toLocal().toIso8601String().split('T').first}',
                  style: TextStyle(color: Colors.grey[300]),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Winner: ${controller.getPlayerName(match.winnerId ?? '')}',
                          style: TextStyle(color: Colors.grey[300]),
                        ),
                        const SizedBox(height: 5),
                        Text(finalResult),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          controller.navigateToStatistics(match.id),
                      style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text('View stats'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
