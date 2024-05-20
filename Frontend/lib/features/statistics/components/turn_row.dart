import 'package:flutter/material.dart';

class TurnRow extends StatelessWidget {
  final String score1;
  final String remainingScore;
  final String turnNumber;
  final String remainingScore2;
  final String score2;
  final bool isPlayer1WinningTurn;
  final bool isPlayer2WinningTurn;

  const TurnRow({
    super.key,
    required this.score1,
    required this.remainingScore,
    required this.turnNumber,
    required this.remainingScore2,
    required this.score2,
    this.isPlayer1WinningTurn = false,
    this.isPlayer2WinningTurn = false,
  });

  @override
  Widget build(BuildContext context) {
    const TextStyle normalStyle = TextStyle(fontSize: 18);
    const TextStyle winningStyle =
        TextStyle(fontSize: 18, color: Colors.yellow);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              score1,
              textAlign: TextAlign.right,
              style: isPlayer1WinningTurn ? winningStyle : normalStyle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              remainingScore,
              textAlign: TextAlign.center,
              style: isPlayer1WinningTurn ? winningStyle : normalStyle,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            turnNumber,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              remainingScore2,
              textAlign: TextAlign.center,
              style: isPlayer2WinningTurn ? winningStyle : normalStyle,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              score2,
              textAlign: TextAlign.left,
              style: isPlayer2WinningTurn ? winningStyle : normalStyle,
            ),
          ),
        ],
      ),
    );
  }
}
