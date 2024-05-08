import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:backend/src/dart_game_service.dart'; // Verwijzing naar je service
import 'package:supabase_flutter/supabase_flutter.dart';

class EndOfMatchView extends StatelessWidget {
  final String matchId;
  final Function() onQuitAndSave;

  const EndOfMatchView({
    super.key,
    required this.matchId,
    required this.onQuitAndSave,
  });

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, dynamic>>(
      future: _fetchMatchResult(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final winner = snapshot.data?['winner'];
          final winnerScore = snapshot.data?['winner_score'];
          final loserScore = snapshot.data?['loser_score'];
          return Scaffold(
            backgroundColor: const Color(0xFF060606),
            body: Center(
              child: Container(
                padding: const EdgeInsets.all(20),
                margin: const EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white.withOpacity(0.05),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Einde van de match',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '$winner wint!',
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                    Text(
                      'Score: $winnerScore - $loserScore',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: onQuitAndSave,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                      ),
                      child: const Text(
                        'Afsluiten en opslaan',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _fetchMatchResult() async {
    try {
      final gameService = DartGameService(Supabase.instance.client);
      final matchResult = await gameService.getEndOfMatchResult(matchId);
      return matchResult;
    } catch (e) {
      throw Exception('Failed to fetch match result: $e');
    }
  }
}
