import 'package:flutter/material.dart';
import 'score_input.dart';
import 'match_status.dart';
import 'end_of_match_view.dart';

class GameplayView extends StatefulWidget {
  const GameplayView({Key? key});

  @override
  _GameplayViewState createState() => _GameplayViewState();
}

class _GameplayViewState extends State<GameplayView> {
  int playerOneScore = 501;
  int playerTwoScore = 501;
  String playerOneName = 'Speler 1';
  String playerTwoName = 'Speler 2';
  int currentPlayer = 1;
  List<int> playerOneThrows = [];
  List<int> playerTwoThrows = [];
  int playerOneLegs = 0;
  int playerTwoLegs = 0;
  bool matchEnded = false;

  void _saveAndQuit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gameplay', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('./assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          matchEnded
              ? EndOfMatchView(
                  winner: playerOneScore == 0 ? playerOneName : playerTwoName,
                  loser: playerOneScore != 0 ? playerOneName : playerTwoName,
                  winnerScore:
                      playerOneScore == 0 ? playerOneScore : playerTwoScore,
                  loserScore:
                      playerOneScore != 0 ? playerOneScore : playerTwoScore,
                  onQuitAndSave: _saveAndQuit,
                )
              : Column(
                  children: [
                    Expanded(
                      child: MatchStatus(matchId: ''),
                    ),
                    Expanded(
                      child: ScoreInput(
                        matchId: '',
                        currentLegId: '',
                        currentSetId: '',
                        currentPlayerId: '',
                      ),
                    ),
                  ],
                ),
        ],
      ),
    );
  }
}
