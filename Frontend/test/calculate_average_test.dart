import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/turn.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darts_application/models/match_statistics.dart';

void main() {
  group('Average Score Calculation tests', () {
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

    // create an empty match object
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

    Map<int, List<Map<String, dynamic>>> legDataBySet = {};

    MatchStatisticsModel matchStatistics = MatchStatisticsModel(
      turns: turns,
      match: match,
      legDataBySet: legDataBySet,
      setIds: [],
    );

    test('Calculate average score', () {
      expect(matchStatistics.calculateAverageScore('1'), 136.64);
    });

    test('Calculate first nine average', () {
      expect(matchStatistics.calculateFirstNineAverage('1'), 140.0);
    });

    test('Calculate average per dart', () {
      expect(matchStatistics.calculateAveragePerDart('1'), 45.55);
    });
  });
}
