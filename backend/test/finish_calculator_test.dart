import 'dart:async';

import 'package:backend/backend.dart';
import 'package:test/test.dart';

void main() {
  group('Backtracking tests', () {
    FinishCalculator finishCalculator = FinishCalculator();

    setUp(() {});

    test('First Test', () {
      expect(finishCalculator.getThrowSuggestion(53, 3), ['3', 'D25']);
    });

    test('Second Test', () {
      finishCalculator.findSolutions([], 15, 3);
      var solutions =
          finishCalculator.chooseBestSolutions(finishCalculator.suggestions);
      expect(solutions.length, 23);
    });

    test('Third Test', () {
      expect(finishCalculator.getThrowSuggestion(8, 3), ['D4']);
    });

    test('Fourth Test', () {
      expect(finishCalculator.getThrowSuggestion(182, 3), null);
    });

    test('Fifth Test', () {
      DateTime startTime = DateTime.now();
      finishCalculator.getThrowSuggestion(134, 3);
      DateTime endTime = DateTime.now();
      Duration elapsed = endTime.difference(startTime);
      bool result = false;
      print(
          'suggestion calculation took:${elapsed.inMilliseconds} miliseconds');
      if (elapsed.inMilliseconds > 500) {
        result = false;
      } else {
        result = true;
      }
      expect(result, true);
    });
  });
}
