import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/features/gameplay/score_suggestion.dart';

class ScoreInput extends StatelessWidget {
  final MatchStore matchStore;

  const ScoreInput({
    super.key,
    required this.matchStore,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Observer(
              builder: (_) {
                return AnimatedAngledBox(
                  isPlayer1: true,
                  suggestion: matchStore.showPlayer1Suggestion ? matchStore.player1Suggestion : '',
                );
              },
            ),
            Observer(
              builder: (_) {
                return AnimatedAngledBox(
                  isPlayer1: false,
                  suggestion: matchStore.showPlayer2Suggestion ? matchStore.player2Suggestion : '',
                );
              },
            ),
          ],
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          height: 80, // Fixed height
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(child: undoButton()),
              const SizedBox(width: 10), // Add spacing between buttons
              Expanded(child: scoreDisplay()),
              const SizedBox(width: 10), // Add spacing between buttons
              Expanded(child: enterButton()),
            ],
          ),
        ),
      ],
    );
  }

  Widget undoButton() {
    return ElevatedButton(
      onPressed: () {
        matchStore.undoLastScore();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCD0612),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text('Undo', style: TextStyle(color: Colors.white)),
    );
  }

  Widget scoreDisplay() {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 15),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white, width: 2),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Observer(
        builder: (_) => Text(
          matchStore.temporaryScore.toString(),
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Widget enterButton() {
    return ElevatedButton(
      onPressed: () {
        // Logic to validate and submit the score
        matchStore.recordScore(int.parse(matchStore.temporaryScore.toString()));
        matchStore.updateTemporaryScore(''); // Reset temporary score after submitting
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCD0612),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
      ),
      child: const Text('Enter', style: TextStyle(color: Colors.white)),
    );
  }
}
