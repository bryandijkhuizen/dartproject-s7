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
                return matchStore.showPlayer1Suggestion
                    ? AnimatedAngledBox(
                        isPlayer1: true,
                        matchStore: matchStore,
                      )
                    : const SizedBox.shrink();
              },
            ),
            Observer(
              builder: (_) {
                return matchStore.showPlayer2Suggestion
                    ? AnimatedAngledBox(
                        isPlayer1: false,
                        matchStore: matchStore,
                      )
                    : const SizedBox.shrink();
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
              Expanded(child: enterButton(context)),
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

  Widget enterButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        int score = int.parse(matchStore.temporaryScore);
        if (score < 50) {
          _showCheckoutDialog(context, score);
        } else {
          matchStore.recordScore(score);
          matchStore.updateTemporaryScore(''); // Reset temporary score after submitting
        }
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

  void _showCheckoutDialog(BuildContext context, int score) {
    TextEditingController dartsController = TextEditingController();
    TextEditingController attemptsController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.grey[850],
          title: const Text(
            'Enter Checkout Details',
            style: TextStyle(color: Colors.white),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: dartsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Darts for Checkout',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
              TextField(
                controller: attemptsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Double Attempts',
                  labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
                style: const TextStyle(color: Colors.white),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel', style: TextStyle(color: Colors.white)),
            ),
            TextButton(
              onPressed: () {
                int dartsForCheckout = int.parse(dartsController.text);
                int doubleAttempts = int.parse(attemptsController.text);
                matchStore.recordScore(score, dartsForCheckout: dartsForCheckout, doubleAttempts: doubleAttempts);
                matchStore.updateTemporaryScore(''); // Reset temporary score after submitting
                Navigator.of(context).pop();
              },
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }
}