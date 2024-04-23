import 'package:flutter/material.dart';

class MatchStatus extends StatelessWidget {
  final int playerOneScore;
  final int playerTwoScore;
  final String playerOneName;
  final String playerTwoName;
  final int currentPlayer;
  final List<int> playerOneLastThrows;
  final List<int> playerTwoLastThrows;
  final int playerOneLegs;
  final int playerTwoLegs;

  const MatchStatus({
    super.key,
    required this.playerOneScore,
    required this.playerTwoScore,
    required this.playerOneName,
    required this.playerTwoName,
    required this.currentPlayer,
    required this.playerOneLastThrows,
    required this.playerTwoLastThrows,
    required this.playerOneLegs,
    required this.playerTwoLegs,
  });

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final bool isPlayerOneTurn = currentPlayer == 1;
    final bool isPlayerTwoTurn = currentPlayer == 2;
    const TextStyle nameStyle = TextStyle(
      fontWeight: FontWeight.bold,
      color: Colors.white,
      fontSize: 18,
    );
    const TextStyle scoreStyle = TextStyle(
      color: Colors.white,
      fontSize: 36,
      fontWeight: FontWeight.bold,
    );
    final TextStyle legsStyle = TextStyle(
      color: colorScheme.secondary,
      fontSize: 14,
    );

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      color: const Color(0xFF060606),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  '$playerOneName  Legs: $playerOneLegs',
                  style: nameStyle,
                  textAlign: TextAlign.start,
                ),
              ),
              Expanded(
                child: Text(
                  '$playerTwoName  Legs: $playerTwoLegs',
                  style: nameStyle,
                  textAlign: TextAlign.end,
                ),
              ),
            ],
          ),

          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                child: Text(
                  playerOneScore.toString(),
                  style: scoreStyle.copyWith(color: isPlayerOneTurn ? colorScheme.secondary : Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                child: Text(
                  playerTwoScore.toString(),
                  style: scoreStyle.copyWith(color: isPlayerTwoTurn ? colorScheme.secondary : Colors.white),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Text(
                      i < playerOneLastThrows.length ? playerOneLastThrows[i].toString() : '-',
                      style: legsStyle.copyWith(color: isPlayerOneTurn ? colorScheme.secondary : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
                const SizedBox(width: 8),
                for (int i = 0; i < 3; i++)
                  Expanded(
                    child: Text(
                      i < playerTwoLastThrows.length ? playerTwoLastThrows[i].toString() : '-',
                      style: legsStyle.copyWith(color: isPlayerTwoTurn ? colorScheme.secondary : Colors.white),
                      textAlign: TextAlign.center,
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
