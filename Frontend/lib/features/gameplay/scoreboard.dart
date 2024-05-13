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
        builder: (_) => Column(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // ignore: unrelated_type_equality_checks
                playerName(matchStore.matchModel.player1LastName, matchStore.matchModel.startingPlayerId == matchStore.matchModel.player1Id, matchStore.currentPlayerId == matchStore.matchModel.player1Id),
                Text(
                  // ignore: collection_methods_unrelated_type
                  '${matchStore.legWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.legWins[matchStore.matchModel.player2Id] ?? 0}',
                  style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                ),
                // ignore: unrelated_type_equality_checks
                playerName(matchStore.matchModel.player2LastName, matchStore.matchModel.startingPlayerId == matchStore.matchModel.player2Id, matchStore.currentPlayerId == matchStore.matchModel.player2Id),
              ],
            ),
            Text(
              // ignore: collection_methods_unrelated_type
              '${matchStore.setWins[matchStore.matchModel.player1Id] ?? 0} - ${matchStore.setWins[matchStore.matchModel.player2Id] ?? 0}',
              style: const TextStyle(color: Colors.white70, fontSize: 18),
            ),
            const SizedBox(height: 10),
            latestScoresRow(),
          ],
        ),
      ),
    );
  }

  Widget playerName(String name, bool isStartingPlayer, bool isCurrentPlayer) {
    return Expanded(
      child: Text(
        isStartingPlayer ? '$name *' : name,
        textAlign: TextAlign.center,
        style: TextStyle(
          color: isCurrentPlayer ? Colors.yellow : Colors.white,
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget latestScoresRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(matchStore.lastFiveScores.length, (index) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(5)
          ),
          child: Text(
            matchStore.lastFiveScores[index].toString(),
            style: const TextStyle(color: Colors.white, fontSize: 16),
          ),
        );
      }),
    );
  }
}
