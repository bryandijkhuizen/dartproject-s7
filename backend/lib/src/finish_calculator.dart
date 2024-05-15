class FinishCalculator {
  int maxDarts = 3;
  List<String> modifiers = ['', 'S', 'D', 'T'];

  List<String>? getThrowSuggestion(int remainingScore, int dartsLeft) {
    if (remainingScore > 170) {
      return null;
    }
    List<List<String>> suggestions = [];
    findSolutions([], remainingScore, dartsLeft, suggestions);
    return chooseBestSolutions(suggestions).first;
  }

  List<List<String>> chooseBestSolutions(List<List<String>> allSuggestions) {
    List<List<String>> leastThrowSuggestions = [];

    for (int i = 1; i <= 3; i++) {
      leastThrowSuggestions =
          allSuggestions.where((element) => element.length == i).toList();
      if (leastThrowSuggestions.isNotEmpty) {
        break;
      }
    }
    return leastThrowSuggestions;
  }

  void findSolutions(
      List<String> currentTree, int remainingScore, int dartsLeft, List<List<String>> suggestions) {
    if (remainingScore == 0 && currentTree.isNotEmpty && currentTree.last.contains('D')) {
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

          newTree.add('${modifiers[i]}$j');
          findSolutions(newTree, remainingScore - j * i, dartsLeft - 1, suggestions);
        }
      }
      if (dartsLeft == 1 && i == 2) {
        for (int j = 1; j <= 20; j++) {
          List<String> newTree = List.from(currentTree);
          newTree.add('D$j');
          findSolutions(newTree, remainingScore - j * i, dartsLeft - 1, suggestions);
        }
      }
    }

    if (remainingScore >= 50 && dartsLeft > 0) {
      List<String> newTree = List.from(currentTree);
      newTree.add('D25');
      findSolutions(newTree, remainingScore - 50, dartsLeft - 1, suggestions);
    }

    if (remainingScore >= 25 && dartsLeft > 0) {
      List<String> newTree = List.from(currentTree);
      newTree.add('25');
      findSolutions(newTree, remainingScore - 25, dartsLeft - 1, suggestions);
    }
  }
}
