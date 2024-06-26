import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/turn.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darts_application/models/match_statistics.dart';

void main() {
  List<TurnModel> turns = [
    TurnModel(
      id: 1,
      playerId: '1',
      legId: 1,
      score: 100,
      doubleAttempts: 0,
      doubleHit: false,
      dartsForCheckout: 0,
      isDeadThrow: false,
    ),
    TurnModel(
      id: 2,
      playerId: '1',
      legId: 1,
      score: 140,
      doubleAttempts: 0,
      dartsForCheckout: 0,
      doubleHit: false,
      isDeadThrow: false,
    ),
    TurnModel(
      id: 3,
      playerId: '1',
      legId: 1,
      score: 180,
      doubleAttempts: 0,
      dartsForCheckout: 0,
      doubleHit: false,
      isDeadThrow: false,
    ),
    TurnModel(
      id: 4,
      playerId: '1',
      legId: 1,
      score: 81,
      doubleAttempts: 1,
      dartsForCheckout: 2,
      doubleHit: true,
      isDeadThrow: false,
    ),
  ];

  // create a match object
  MatchModel match = MatchModel(
    id: '1',
    player1Id: '1',
    player2Id: '2',
    date: DateTime.now(),
    setTarget: 3,
    legTarget: 3,
    startingScore: 501,
    player1LastName: 'Doe',
    player2LastName: 'Smith',
  );

  // set up the leg data
  Map<int, List<Map<String, dynamic>>> legDataBySet = {
    1: [
      {'id': 1, 'winner_id': '1'},
    ],
  };

  // set up the set ids
  List<int> setIds = [1];

  MatchStatisticsModel matchStatistics = MatchStatisticsModel(
    turns: turns,
    match: match,
    legDataBySet: legDataBySet,
    setIds: setIds,
  );

  group('Average Score Calculation tests', () {
    test('Calculate average score', () {
      expect(matchStatistics.calculateAverageScore('1'), 136.64);
    });

    test('Calculate first nine average', () {
      expect(matchStatistics.calculateFirstNineAverage('1'), 140.0);
    });

    test('Calculate average per dart', () {
      expect(matchStatistics.calculateAveragePerDart('1'), 45.55);
    });

    test('Calculate leg average', () {
      expect(matchStatistics.calculateLegAverage('1', 1), 136.64);
    });

    test('Calculate set average', () {
      expect(matchStatistics.calculateSetAverage('1', 1), 136.64);
    });

    test('Calculate darts used in leg', () {
      expect(matchStatistics.getScoresAndDarts('1', 1)[1], 11);
    });
  });

  group('Checkout Percentage Calculation tests', () {
    test('Calculate checkout percentage', () {
      expect(matchStatistics.calculateCheckoutPercentage('1'), 100.0);
    });

    test('Calculate checkouts/attempts', () {
      expect(matchStatistics.checkoutOutsVsAttempts('1'), '1/1');
    });
  });

  group('Match results tests', () {
    test('Calculate sets won', () {
      expect(matchStatistics.calculateSetsWon('1'), 1);
    });

    test('Calculate legs won', () {
      expect(matchStatistics.calculateLegsWon(1, '1'), 1);
    });
  });
}
