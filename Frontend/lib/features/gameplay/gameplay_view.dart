import 'package:flutter/material.dart';
import 'score_input.dart';
import 'match_status.dart';
import 'end_of_match_view.dart';

class GameplayView extends StatefulWidget {
  const GameplayView({super.key});

  @override
  // ignore: library_private_types_in_public_api
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

  void _updateScore(int score) {
    if (currentPlayer == 1) {
      if (playerOneScore - score >= 0) {
        setState(() {
          playerOneScore -= score;
          playerOneThrows.add(score);
          if (playerOneThrows.length == 3) {
            currentPlayer = 2;
            playerOneThrows.clear();
            if (playerOneScore == 0) {
              playerOneLegs += 1;
              _checkMatchEnd();
            }
          }
        });
      }
    } else {
      if (playerTwoScore - score >= 0) {
        setState(() {
          playerTwoScore -= score;
          playerTwoThrows.add(score);
          if (playerTwoThrows.length == 3) {
            currentPlayer = 1;
            playerTwoThrows.clear();
            if (playerTwoScore == 0) {
              playerTwoLegs += 1;
              _checkMatchEnd();
            }
          }
        });
      }
    }
  }

  void _undoLastThrow() {
  }

  void _checkMatchEnd() {
    if (playerOneLegs == 3 || playerTwoLegs == 3) {
      setState(() => matchEnded = true);
    } else {
      playerOneScore = 501;
      playerTwoScore = 501;
    }
  }

  void _saveAndQuit() {
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: matchEnded
          ? EndOfMatchView(
              winner: playerOneScore == 0 ? playerOneName : playerTwoName,
              loser: playerOneScore != 0 ? playerOneName : playerTwoName,
              winnerScore:
                  playerOneScore == 0 ? playerOneScore : playerTwoScore,
              loserScore: playerOneScore != 0 ? playerOneScore : playerTwoScore,
              onQuitAndSave: _saveAndQuit,
            )
          : Column(
              children: [
                MatchStatus(
                  playerOneScore: playerOneScore,
                  playerTwoScore: playerTwoScore,
                  playerOneName: playerOneName,
                  playerTwoName: playerTwoName,
                  currentPlayer: currentPlayer,
                  playerOneLastThrows: playerOneThrows,
                  playerTwoLastThrows: playerTwoThrows,
                  playerOneLegs: playerOneLegs,
                  playerTwoLegs: playerTwoLegs,
                ),
                Expanded(
                  child: ScoreInput(
                    onScoreEntered: _updateScore,
                    onLegFinished: () {},
                    onUndo: _undoLastThrow,
                  ),
                ),
              ],
            ),
    );
  }
}
