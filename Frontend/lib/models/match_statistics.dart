import 'package:darts_application/models/match.dart';
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

  double calculateAverageScore(String playerId) {
    int totalScore = 0;
    int totalDarts = 0;

    for (final setId in setIds) {
      List<Map<String, dynamic>> legs = legDataBySet[setId]!;

      for (final leg in legs) {
        int legId = leg['id'];
        Map<int, int> scoresAndDarts =
            calculateScoresAndDartsPerLeg(playerId, legId);
        totalScore += scoresAndDarts.keys.first;
        totalDarts += scoresAndDarts.values.first;
      }
    }

    double average = totalScore / totalDarts * 3;

    return double.parse(average.toStringAsFixed(2));
  }

  double calculateFirstNineAverage(String playerId) {
    // Retrieve all turns for the given player and sort by turn.id
    List<TurnModel> playerTurns = turns
        .where((turn) => turn.playerId == playerId)
        .toList()
      ..sort((a, b) => a.id.compareTo(b.id));

    // If there are fewer than 3 turns, calculate the average for the available turns
    if (playerTurns.isEmpty) {
      return 0.0;
    }

    int totalScore = 0;
    int totalDarts = 0;

    // Limit to the first 3 turns (9 darts)
    for (int i = 0; i < playerTurns.length && i < 3; i++) {
      totalScore += playerTurns[i].score;
      totalDarts += 3;
    }

    if (totalDarts == 0) {
      return 0.0;
    }

    double average = totalScore / totalDarts * 3;
    return average;
  }

  double calculateAveragePerDart(String playerId) {
    double average = calculateAverageScore(playerId) / 3;
    return double.parse((average).toStringAsFixed(2));
  }

  double calculateCheckoutPercentage(String playerId) {
    List<TurnModel> playerTurns =
        turns.where((turn) => turn.playerId == playerId).toList();

    int doubleAttempts = 0;
    int doubleHits = 0;
    int dartsForCheckout = 0;

    // doubleHit is a bool that is true if the player hit a double so summing this will give the amount of doubles hit
    for (final turn in playerTurns) {
      if (turn.doubleHit != null && turn.doubleHit!) {
        doubleHits++;
      }
      if (turn.doubleAttempts != null) {
        doubleAttempts += turn.doubleAttempts!;
      }
      if (turn.dartsForCheckout != null) {
        dartsForCheckout += turn.dartsForCheckout!;
      }
    }

    if (doubleAttempts == 0) {
      return 0;
    }

    double checkoutPercentage = (doubleHits / doubleAttempts) * 100;

    return double.parse(checkoutPercentage.toStringAsFixed(2));
  }

  String checkoutOutsVsAttempts(String playerId) {
    List<TurnModel> playerTurns =
        turns.where((turn) => turn.playerId == playerId).toList();

    int checkoutAttempts = 0;
    int checkoutHits = 0;

    for (final turn in playerTurns) {
      if (turn.doubleAttempts != null) {
        checkoutAttempts += turn.doubleAttempts!;
      }
      if (turn.doubleHit != null && turn.doubleHit!) {
        checkoutHits += 1;
      }
    }

    return '$checkoutHits/$checkoutAttempts';
  }

  double calculateSetAverage(String playerId, int setId) {
    // get all legs in the set
    List<Map<String, dynamic>> legs = legDataBySet[setId]!;

    int totalScore = 0;
    int dartsUsed = 0;

    for (final leg in legs) {
      int legId = leg['id'];
      Map<int, int> scoresAndDarts =
          calculateScoresAndDartsPerLeg(playerId, legId);
      totalScore += scoresAndDarts.keys.first;
      dartsUsed += scoresAndDarts.values.first;
    }

    double average = totalScore / dartsUsed * 3;

    return double.parse(average.toStringAsFixed(2));
  }

  double calculateLegAverage(String playerId, int legId) {
    int totalScore = calculateScoresAndDartsPerLeg(playerId, legId).keys.first;
    int dartsUsed = calculateScoresAndDartsPerLeg(playerId, legId).values.first;

    double average = totalScore / dartsUsed * 3;

    return double.parse(average.toStringAsFixed(2));
  }

  Map<int, int> calculateScoresAndDartsPerLeg(String playerId, int legId) {
    int amountOfDartsUsed = calculateTotalDartsUsed(playerId, legId);

    // get the total score of the player in the leg
    List<TurnModel> playerTurns = turns
        .where((turn) => turn.legId == legId && turn.playerId == playerId)
        .toList();

    int totalScore = 0;

    for (final turn in playerTurns) {
      totalScore += turn.score;
    }

    return {totalScore: amountOfDartsUsed};
  }

  int calculateTotalDartsUsed(String playerId, int legId) {
    int dartsBeforeCheckout = 0;

    List<TurnModel> playerTurns = turns
        .where((turn) => turn.legId == legId && turn.playerId == playerId)
        .toList();

    for (final turn in playerTurns) {
      dartsBeforeCheckout += 3;
      if (turn.doubleHit == true) {
        dartsBeforeCheckout -= 3 - turn.dartsForCheckout!;
        break;
      }
    }

    return dartsBeforeCheckout;
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
