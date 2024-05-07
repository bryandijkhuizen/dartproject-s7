import 'package:flutter/material.dart';
import 'package:backend/src/dart_game_service.dart';  // Ensure this path is correct
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchStatus extends StatefulWidget {
  final String matchId;

  const MatchStatus({super.key, required this.matchId});

  @override
  _MatchStatusState createState() => _MatchStatusState();
}

class _MatchStatusState extends State<MatchStatus> {
  late final DartGameService _dartGameService;

  @override
  void initState() {
    super.initState();
    if (widget.matchId.isEmpty) {
      throw Exception('Match ID is required for MatchStatus widget');
    }
    _dartGameService = DartGameService(Supabase.instance.client);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: _dartGameService.subscribeToMatchChanges(widget.matchId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error.toString()}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          var matchData = snapshot.data!.first;
          bool isPlayerOneTurn = matchData['current_turn'] == 'player_1_id';
          String playerOneName = matchData['player_1_name'] ?? 'Player 1'; // Default if null
          String playerTwoName = matchData['player_2_name'] ?? 'Player 2'; // Default if null
          int playerOneScore = matchData['player_1_score'] ?? 0; // Default if null
          int playerTwoScore = matchData['player_2_score'] ?? 0; // Default if null
          String legStand = matchData['leg_stand'] ?? '0 - 0'; // Default if null

          return buildMatchUI(playerOneName, playerOneScore, playerTwoName, playerTwoScore, isPlayerOneTurn, legStand);
        } else {
          return const Center(child: Text('No data available'));
        }
      },
    );
  }

  Widget buildMatchUI(String playerOneName, int playerOneScore, String playerTwoName, int playerTwoScore, bool isPlayerOneTurn, String legStand) {
    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            legStand,
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
                  buildPlayerScore(playerOneName, playerOneScore, isPlayerOneTurn),
                  const VerticalDivider(color: Colors.white, width: 3),
                  buildPlayerScore(playerTwoName, playerTwoScore, !isPlayerOneTurn),
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
