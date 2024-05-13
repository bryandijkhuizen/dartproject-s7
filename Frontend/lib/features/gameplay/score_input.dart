import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';

class ScoreInput extends StatelessWidget {
  final MatchStore matchStore;

  const ScoreInput({super.key, required this.matchStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              undoButton(),
              scoreDisplay(),
              enterButton(),
            ],
          ),
        ],
      ),
    );
  }

  Widget undoButton() {
    return ElevatedButton(
      onPressed: () {
        matchStore.undoLastScore();
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red, // Background color
      ),
      child: const Icon(Icons.undo, color: Colors.white),
    );
  }

  Widget scoreDisplay() {
    return Observer(
      builder: (_) => Text(
        matchStore.temporaryScore.toString(),
        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
    );
  }

  Widget enterButton() {
    return ElevatedButton(
      onPressed: () {
        // Logic to validate and submit the score
        matchStore.recordScore(int.parse(matchStore.temporaryScore.toString()));
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.green, // Background color
      ),
      child: const Text('Enter', style: TextStyle(color: Colors.white)),
    );
  }
}
