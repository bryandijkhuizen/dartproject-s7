import 'package:flutter/material.dart';
import 'package:darts_application/stores/match_store.dart';

class Numpad extends StatelessWidget {
  final MatchStore matchStore;

  const Numpad({super.key, required this.matchStore});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.5,
        children: List.generate(10, (index) {
          return numpadButton(index == 9 ? 0 : index + 1);
        })..add(
            deleteButton(),
          ),
      ),
    );
  }

  Widget numpadButton(int number) {
    return ElevatedButton(
      onPressed: () {
        matchStore.updateTemporaryScore(matchStore.temporaryScore + number.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(
        number.toString(),
        style: const TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget deleteButton() {
    return ElevatedButton(
      onPressed: () {
        if (matchStore.temporaryScore.isNotEmpty) {
          matchStore.updateTemporaryScore(matchStore.temporaryScore.substring(0, matchStore.temporaryScore.length - 1));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: const Icon(Icons.backspace, color: Colors.white),
    );
  }
}
