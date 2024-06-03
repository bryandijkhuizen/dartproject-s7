import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';

class Numpad extends StatelessWidget {
  final MatchStore matchStore;

  const Numpad({super.key, required this.matchStore});

  @override
  Widget build(BuildContext context) {
    return Observer(
      builder: (_) {
        bool isDisabled = matchStore.currentPlayerId != matchStore.matchModel.player1Id;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: GridView.count(
            crossAxisCount: 3,
            childAspectRatio: 2.2,
            mainAxisSpacing: 5,
            crossAxisSpacing: 5,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            children: [
              for (int i = 1; i <= 9; i++) numpadButton(i, isDisabled),
              Container(),
              numpadButton(0, isDisabled),
              deleteButton(isDisabled),
            ],
          ),
        );
      },
    );
  }

  Widget numpadButton(int number, bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : () {
        matchStore.updateTemporaryScore(matchStore.temporaryScore + number.toString());
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFCD0612),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      child: Center(
        child: Text(
          number.toString(),
          style: const TextStyle(fontSize: 24, color: Colors.white),
        ),
      ),
    );
  }

  Widget deleteButton(bool isDisabled) {
    return ElevatedButton(
      onPressed: isDisabled ? null : () {
        if (matchStore.temporaryScore.isNotEmpty) {
          matchStore.updateTemporaryScore(matchStore.temporaryScore.substring(0, matchStore.temporaryScore.length - 1));
        }
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF921B22),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: const EdgeInsets.symmetric(vertical: 10),
        textStyle: const TextStyle(fontSize: 24, color: Colors.white),
      ),
      child: const Icon(Icons.backspace, color: Colors.white),
    );
  }
}
