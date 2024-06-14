import 'package:darts_application/features/statistics/stores/statistics_store.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match.dart';
import 'package:provider/provider.dart';

class MatchCard extends StatelessWidget {
  final MatchModel match;

  MatchCard({required this.match, super.key});

  @override
  Widget build(BuildContext context) {
    final statisticsStore = Provider.of<StatisticsStore>(context);
    final matchId = int.parse(match.id);

    return FutureBuilder<String>(
      future: statisticsStore.getMatchResult(matchId),
      builder: (context, snapshot) {
        //handle null as if there was no match
        if (snapshot.data == null) {
          return const SizedBox.shrink();
        }
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
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${statisticsStore.getPlayerName(match.player1Id)} vs ${statisticsStore.getPlayerName(match.player2Id)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  'Date: ${match.date.toLocal().toIso8601String().split('T').first}',
                  style: TextStyle(color: Colors.grey[600]),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Winner: ${statisticsStore.getPlayerName(match.winnerId ?? '')}',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        const SizedBox(height: 5),
                        Text(finalResult),
                      ],
                    ),
                    ElevatedButton(
                      onPressed: () =>
                          statisticsStore.navigateToStatistics(match.id),
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
