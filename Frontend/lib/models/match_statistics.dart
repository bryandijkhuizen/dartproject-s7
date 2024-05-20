import 'package:darts_application/models/leg.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/set.dart';
import 'package:darts_application/models/turn.dart';

class MatchStatisticsModel {
  final List<TurnModel> turns;
  final MatchModel match;
  final Map<int, List<Map<String, dynamic>>> legDataBySet;
  final List<int> setIds;

  MatchStatisticsModel({
    required this.turns,
    required this.match,
    required this.legDataBySet,
    required this.setIds,
  });

  // calculate the average score of a player
  double calculateAverageScore(String playerId) {
    // first get all the scores of the turns with the given playerId
    List<int> scores = turns
        .where((turn) => turn.playerId == playerId)
        .map((turn) => turn.score)
        .toList();

    // then calculate the average
    double average = scores.reduce((a, b) => a + b) / scores.length;

    // round to 2 decimal places
    average = double.parse((average).toStringAsFixed(2));

    return average;
  }

  double calculateFirstNineAverage(String playerId) {
    List<int> scores = turns
        .where((turn) => turn.playerId == playerId)
        .map((turn) => turn.score)
        .toList();

    if (scores.length < 3) {
      double average = scores.reduce((a, b) => a + b) / scores.length;

      return double.parse((average).toStringAsFixed(2));
    } else {
      scores = scores.sublist(0, 3);

      double average = scores.reduce((a, b) => a + b) / scores.length;

      average = double.parse((average).toStringAsFixed(2));

      return average;
    }
  }

  double calculateAveragePerDart(String playerId) {
    return calculateAverageScore(playerId) / 3;
  }

  int calculateCheckoutPercentage(String playerId) {
    // use turn.doubleAttempts and turn.doubleHits to calculate the checkout percentage no decimal places
    List<TurnModel> playerTurns =
        turns.where((turn) => turn.playerId == playerId).toList();

    int checkoutAttempts = 0;
    int checkoutHits = 0;

    for (final turn in playerTurns) {
      if (turn.doubleAttempts != null && turn.doubleHits != null) {
        checkoutAttempts += turn.doubleAttempts!;
        checkoutHits += turn.doubleHits!;
      }
    }

    if (checkoutAttempts == 0) {
      return 0;
    }

    return ((checkoutHits / checkoutAttempts) * 100).round();
  }

  String checkoutOutsVsAttempts(String playerId) {
    List<TurnModel> playerTurns =
        turns.where((turn) => turn.playerId == playerId).toList();

    int checkoutAttempts = 0;
    int checkoutHits = 0;

    for (final turn in playerTurns) {
      if (turn.doubleAttempts != null && turn.doubleHits != null) {
        checkoutAttempts += turn.doubleAttempts!;
        checkoutHits += turn.doubleHits!;
      } else {
        checkoutAttempts += 0;
        checkoutHits += 0;
      }
    }

    if (checkoutAttempts == 0 && checkoutHits == 0) {
      return '0/0';
    }
    return '$checkoutHits/$checkoutAttempts';
  }

  double calculateSetAverage(String playerId, int setId) {
    List<int> scores = turns
        .where((turn) => turn.playerId == playerId)
        .where((turn) => legDataBySet[setId]!
            .map((leg) => leg['id'])
            .toList()
            .contains(turn.legId))
        .map((turn) => turn.score)
        .toList();

    double average = scores.reduce((a, b) => a + b) / scores.length;

    average = double.parse((average).toStringAsFixed(2));

    return average;
  }

  double calculateLegAverage(String playerId, int legId) {
    List<int> scores = turns
        .where((turn) => turn.playerId == playerId)
        .where((turn) => turn.legId == legId)
        .map((turn) => turn.score)
        .toList();

    double average = scores.reduce((a, b) => a + b) / scores.length;

    average = double.parse((average).toStringAsFixed(2));

    return average;
  }

  int calculateLegsWon(int setId, String playerId) {
    int legsWon = 0;
    for (final leg in legDataBySet[setId]!) {
      if (leg['winner_id'] == playerId) {
        legsWon++;
      }
    }
    return legsWon;
  }

  int calculateSetsWon(String playerId) {
    int setsWon = 0;
    for (final setId in setIds) {
      final playerLegsWon = calculateLegsWon(setId, playerId);
      final opponentLegsWon = calculateLegsWon(setId,
          playerId == match.player1Id ? match.player2Id : match.player1Id);
      if (playerLegsWon > opponentLegsWon) {
        setsWon++;
      }
    }
    return setsWon;
  }
}
