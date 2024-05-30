import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';

class Scoreboard extends StatelessWidget {
  final MatchStore matchStore;

  const Scoreboard({super.key, required this.matchStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Observer(
        builder: (_) {
          return Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  playerName(
                    context,
                    matchStore.matchModel.player1LastName,
                    matchStore.matchModel.startingPlayerId ==
                        matchStore.matchModel.player1Id,
                    matchStore.currentPlayerId ==
                        matchStore.matchModel.player1Id,
                    Alignment.centerLeft,
                  ),
                  scoreDisplay(context, matchStore),
                  playerName(
                    context,
                    matchStore.matchModel.player2LastName,
                    matchStore.matchModel.startingPlayerId ==
                        matchStore.matchModel.player2Id,
                    matchStore.currentPlayerId ==
                        matchStore.matchModel.player2Id,
                    Alignment.centerRight,
                  ),
                ],
              ),
              const SizedBox(height: 10),
              scoreSeparator(context, matchStore),
              const SizedBox(height: 10),
            ],
          );
        },
      ),
    );
  }

  Widget playerName(BuildContext context, String name, bool isStartingPlayer,
      bool isCurrentPlayer, Alignment alignment) {
    double fontSize = MediaQuery.of(context).size.width / 18;
    return Expanded(
      child: Column(
        crossAxisAlignment: alignment == Alignment.centerLeft
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: alignment == Alignment.centerLeft
                ? MainAxisAlignment.start
                : MainAxisAlignment.end,
            children: [
              if (isStartingPlayer)
                const Icon(Icons.star, color: Colors.yellow, size: 24),
              const SizedBox(width: 4),
              Text(
                name,
                style: TextStyle(
                  color: isCurrentPlayer ? Colors.yellow : Colors.white,
                  fontSize: fontSize,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Text(
            alignment == Alignment.centerLeft
                ? matchStore.currentScorePlayer1.toString()
                : matchStore.currentScorePlayer2.toString(),
            style: TextStyle(
              color: alignment == Alignment.centerLeft && isCurrentPlayer
                  ? Colors.yellow
                  : alignment == Alignment.centerRight && isCurrentPlayer
                      ? Colors.yellow
                      : Colors.white,
              fontSize: fontSize * 1.1,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget scoreDisplay(BuildContext context, MatchStore matchStore) {
    double fontSizeScore = MediaQuery.of(context).size.width / 16;
    return Column(
      children: [
        Text(
          '${matchStore.legWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.legWins[matchStore.matchModel.player2Id] ?? 0}',
          style: TextStyle(
              color: Colors.white,
              fontSize: fontSizeScore,
              fontWeight: FontWeight.bold),
        ),
        if (matchStore.matchModel.setTarget != 1)
          Text(
            '${matchStore.setWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.setWins[matchStore.matchModel.player2Id] ?? 0}',
            style:
                TextStyle(color: Colors.white70, fontSize: fontSizeScore * 0.85),
          ),
      ],
    );
  }

  Widget scoreSeparator(BuildContext context, MatchStore matchStore) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.2224,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 0,
            bottom: 0,
            left: MediaQuery.of(context).size.width / 2 - 20,
            child: Container(
              width: 1,
              color: Colors.white,
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: Colors.white,
            ),
          ),
          Positioned(
            top: 0,
            left: MediaQuery.of(context).size.width * 0.2, // Adjust to center
            child: latestScoresColumn(context, matchStore, true),
          ),
          Positioned(
            top: 0,
            right: MediaQuery.of(context).size.width * 0.2, // Adjust to center
            child: latestScoresColumn(context, matchStore, false),
          ),
        ],
      ),
    );
  }

  Widget latestScoresColumn(
      BuildContext context, MatchStore matchStore, bool isPlayer1) {
    double fontSize = MediaQuery.of(context).size.width / 24;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final scores = isPlayer1
            ? matchStore.lastFiveScoresPlayer1
            : matchStore.lastFiveScoresPlayer2;
        final scoreEntry =
            index < scores.length ? scores[index] : {};
        final isDeadThrow = scoreEntry['isDeadThrow'] ?? false;
        final score = scoreEntry['score'] ?? '';
        return Container(
          height: 40,
          alignment: Alignment.center,
          child: Text(
            score.toString(),
            textAlign: TextAlign.center,
            style: TextStyle(
              color: isDeadThrow ? Colors.red : Colors.white,
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      }),
    );
  }
}
