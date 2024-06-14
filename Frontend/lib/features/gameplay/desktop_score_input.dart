import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/features/gameplay/score_suggestion.dart';

class DesktopScoreInput extends StatelessWidget {
  final MatchStore matchStore;
  const DesktopScoreInput({super.key, required this.matchStore});

  @override
  Widget build(BuildContext context) {
    final TextEditingController scoreController = TextEditingController();

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          Stack(
            children: [
              Observer(
                builder: (_) {
                  return AnimatedAngledBox(
                    isPlayer1: true,
                    matchStore: matchStore,
                  );
                },
              ),
              Observer(
                builder: (_) {
                  return AnimatedAngledBox(
                    isPlayer1: false,
                    matchStore: matchStore,
                  );
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        matchStore.undoLastScore();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                      ),
                      child: const Text('Undo', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    const SizedBox(height: 5),
                    const Text('Press Z to undo', style: TextStyle(color: Colors.white)),
                  ],
                ),
                const SizedBox(width: 10), // Add spacing between buttons
                Expanded(
                  child: TextFormField(
                    controller: scoreController,
                    autofocus: true,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      hintText: 'Enter score',
                      hintStyle: TextStyle(color: Colors.white.withOpacity(0.6)),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white.withOpacity(0.6)),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                    onChanged: (value) {
                      matchStore.updateTemporaryScore(value);
                    },
                  ),
                ),
                const SizedBox(width: 10), // Add spacing between buttons
                Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        if (matchStore.temporaryScore.isNotEmpty) {
                          matchStore.recordScore(int.parse(matchStore.temporaryScore));
                          matchStore.updateTemporaryScore('');
                          scoreController.clear();
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCD0612),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.zero,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 40),
                      ),
                      child: const Text('Enter', style: TextStyle(color: Colors.white, fontSize: 20)),
                    ),
                    const SizedBox(height: 5),
                    const Text('Press Enter to submit', style: TextStyle(color: Colors.white)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
