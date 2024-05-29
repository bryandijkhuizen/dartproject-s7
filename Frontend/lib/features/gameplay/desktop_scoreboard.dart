import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';

class DesktopScoreboard extends StatelessWidget {
  final MatchStore matchStore;

  const DesktopScoreboard({super.key, required this.matchStore});

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
                  playerDetails(
                    matchStore.matchModel.player1LastName,
                    matchStore.currentScorePlayer1,
                    matchStore.matchModel.startingPlayerId == matchStore.matchModel.player1Id,
                    matchStore.matchModel.player1Id == matchStore.currentPlayerId,
                    true,
                  ),
                  scoreDisplay(matchStore),
                  playerDetails(
                    matchStore.matchModel.player2LastName,
                    matchStore.currentScorePlayer2,
                    matchStore.matchModel.startingPlayerId == matchStore.matchModel.player2Id,
                    matchStore.matchModel.player2Id == matchStore.currentPlayerId,
                    false,
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

  Widget playerDetails(String playerName, int currentScore, bool isStartingPlayer, bool isCurrentPlayer, bool isPlayer1) {
    return Column(
      crossAxisAlignment: isPlayer1 ? CrossAxisAlignment.start : CrossAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: isPlayer1 ? MainAxisAlignment.start : MainAxisAlignment.end,
          children: [
            if (isPlayer1) ...[
              if (isStartingPlayer) const Icon(Icons.star, color: Colors.yellow, size: 24),
              const SizedBox(width: 4),
              Text(
                playerName,
                style: TextStyle(
                  color: isCurrentPlayer ? Colors.yellow : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ] else ...[
              Text(
                playerName,
                style: TextStyle(
                  color: isCurrentPlayer ? Colors.yellow : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              if (isStartingPlayer) const Icon(Icons.star, color: Colors.yellow, size: 24),
            ],
          ],
        ),
        Text(
          currentScore.toString(),
          style: TextStyle(
            color: isCurrentPlayer ? Colors.yellow : Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          textAlign: isPlayer1 ? TextAlign.start : TextAlign.end,
        ),
      ],
    );
  }

  Widget scoreDisplay(MatchStore matchStore) {
    return Column(
      children: [
        Text(
          '${matchStore.legWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.legWins[matchStore.matchModel.player2Id] ?? 0}',
          style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        ),
        if (matchStore.matchModel.setTarget != 1)
          Text(
            '${matchStore.setWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.setWins[matchStore.matchModel.player2Id] ?? 0}',
            style: const TextStyle(color: Colors.white70, fontSize: 20),
          ),
      ],
    );
  }

  Widget scoreSeparator(BuildContext context, MatchStore matchStore) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.25,
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
            left: MediaQuery.of(context).size.width / 2 - 38,
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
            left: MediaQuery.of(context).size.width * 0.18,
            child: latestScoresColumn(context, matchStore, true),
          ),
          Positioned(
            top: 0,
            right: MediaQuery.of(context).size.width * 0.18,
            child: latestScoresColumn(context, matchStore, false),
          ),
        ],
      ),
    );
  }

  Widget latestScoresColumn(BuildContext context, MatchStore matchStore, bool isPlayer1) {
    double fontSize = MediaQuery.of(context).size.width / 48;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (index) {
        final scores = isPlayer1
            ? matchStore.lastFiveScoresPlayer1
            : matchStore.lastFiveScoresPlayer2;
        final scoreEntry = index < scores.length ? scores[index] : {};
        final isDeadThrow = scoreEntry['isDeadThrow'] ?? false;
        final score = scoreEntry['score'] ?? '';
        return Container(
          height: MediaQuery.of(context).size.height * 0.05,
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
