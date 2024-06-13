import 'package:backend/backend.dart';

class FinishCalculator {
  List<List<String>> suggestions = [];
  int maxDarts = 3;
  List<String> modifiers = ['error', '', 'D', 'T'];

  List<String>? getThrowSuggestion(int remainingScore, int dartsLeft) {
    suggestions = [];
    print("start calculation");
    if (remainingScore > 170 || remainingScore <= 0) {
      return null;
    }
    findSolutions([], remainingScore, dartsLeft);
    return chooseBestSolutions(suggestions).first;
  }

  List<List<String>> chooseBestSolutions(List<List<String>> allSuggestions) {
    List<List<String>> leastThrowSuggestions = [];

    for (int i = 1; i <= 3; i++) {
      if (leastThrowSuggestions.isEmpty) {
        leastThrowSuggestions =
            allSuggestions.where((element) => element.length == i).toList();
      }
    }
    return leastThrowSuggestions;
  }

  void findSolutions(
      List<String> currentTree, int remainingScore, int dartsLeft) {
    if (remainingScore == 0 && currentTree.last.contains('D')) {
      suggestions.add(List.from(currentTree));
      return;
    }

    if (dartsLeft == 0 || remainingScore <= 0) {
      return;
    }

    for (int i = 1; i <= 3; i++) {
      if (dartsLeft != 1) {
        for (int j = 1; j <= 20; j++) {
          List<String> newTree = List.from(currentTree);

          newTree.add('${modifiers[i]}${j}');
          findSolutions(newTree, remainingScore - j * i, dartsLeft - 1);
        }
      }
      if (dartsLeft == 1 && i == 2) {
        for (int j = 1; j <= 20; j++) {
          List<String> newTree = List.from(currentTree);
          newTree.add('D${j}');
          findSolutions(newTree, remainingScore - j * i, dartsLeft - 1);
        }
      }
    }

    if (remainingScore >= 50) {
      List<String> newTree = List.from(currentTree);
      newTree.add('D25');
      findSolutions(newTree, remainingScore - 50, dartsLeft - 1);
    }

    if (remainingScore >= 25) {
      List<String> newTree = List.from(currentTree);
      newTree.add('25');
      findSolutions(newTree, remainingScore - 25, dartsLeft - 1);
    }
  }
}
