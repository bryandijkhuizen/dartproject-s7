import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:backend/src/dart_game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchStatus extends StatefulWidget {
  final String matchId;

  const MatchStatus({super.key, required this.matchId});

  @override
  // ignore: library_private_types_in_public_api
  _MatchStatusState createState() => _MatchStatusState();
}

class _MatchStatusState extends State<MatchStatus> {
  late final DartGameService _dartGameService;

  @override
  void initState() {
    super.initState();
    _dartGameService = DartGameService(Supabase.instance.client);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dartGameService.subscribeToMatchChanges(widget.matchId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var matchData = snapshot.data!.first;
          bool isPlayerOneTurn = matchData['current_turn'] == 'player_1_id';
          return buildMatchUI(matchData, isPlayerOneTurn);
        } else {
          return const Center(child: Text('Geen data beschikbaar'));
        }
      },
    );
  }

  Widget buildMatchUI(Map<String, dynamic> matchData, bool isPlayerOneTurn) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            matchData['leg_stand'],
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  buildPlayerScore(matchData['player_1_name'],
                      matchData['player_1_score'], isPlayerOneTurn),
                  Container(
                    width: 3,
                    color: Colors.white,
                    margin: const EdgeInsets.only(top: 8, bottom: 8),
                  ),
                  buildPlayerScore(matchData['player_2_name'],
                      matchData['player_2_score'], !isPlayerOneTurn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayerScore(String name, int score, bool isCurrentTurn) {
    return Expanded(
      child: Column(
        children: [
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: isCurrentTurn ? Colors.yellow : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              color: isCurrentTurn ? Colors.yellow : Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 3,
            color: isCurrentTurn ? Colors.yellow : Colors.white,
            margin: const EdgeInsets.only(top: 4),
          ),
        ],
      ),
    );
  }
}
