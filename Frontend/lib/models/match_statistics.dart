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

  double calculateAverageScore(String playerId) {
    List<TurnModel> playerTurns =
        turns.where((turn) => turn.playerId == playerId).toList();

    int amountOfDartsUsed = 0;

    // for every turn add 3 darts to the amount of darts used
    for (final turn in playerTurns) {
      amountOfDartsUsed += 3;
    }

    for (final turn in playerTurns) {
      if (turn.doubleHit != null && turn.doubleHit!) {
        amountOfDartsUsed -= 3 - turn.dartsForCheckout!;
      }
    }

    double average = match.startingScore / amountOfDartsUsed * 3;

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
    return double.parse(average.toStringAsFixed(2));
  }

  double calculateAveragePerDart(String playerId) {
    double average = calculateAverageScore(playerId) / 3;
    return double.parse((average).toStringAsFixed(2));
  }

  int calculateCheckoutPercentage(String playerId) {
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
    List<TurnModel> setTurns = turns
        .where((turn) => turn.playerId == playerId)
        .where((turn) => legDataBySet[setId]!
            .map((leg) => leg['id'])
            .toList()
            .contains(turn.legId))
        .toList();

    if (setTurns.isEmpty) {
      return 0.0;
    }

    int totalScore = 0;
    int totalDarts = 0;

    int turnsUntilCheckout = setTurns.indexWhere(
        (turn) => turn.dartsForCheckout != null && turn.dartsForCheckout! > 0);

    if (turnsUntilCheckout != -1) {
      int amountOfDarts = turnsUntilCheckout * 3;
      amountOfDarts += setTurns[turnsUntilCheckout].dartsForCheckout!;

      double average = match.startingScore / amountOfDarts * 3;
      return double.parse(average.toStringAsFixed(2));
    } else {
      for (final turn in setTurns) {
        totalScore += turn.score;
        totalDarts += 3;
      }

      if (totalDarts == 0) {
        return 0.0;
      }

      double average = totalScore / totalDarts * 3;
      return double.parse(average.toStringAsFixed(2));
    }
  }

  double calculateLegAverage(String playerId, int legId) {
    List<TurnModel> legTurns = turns
        .where((turn) => turn.playerId == playerId)
        .where((turn) => turn.legId == legId)
        .toList();

    if (legTurns.isEmpty) {
      return 0.0;
    }

    int totalScore = 0;
    int totalDarts = 0;

    int turnsUntilCheckout = legTurns.indexWhere(
        (turn) => turn.dartsForCheckout != null && turn.dartsForCheckout! > 0);

    if (turnsUntilCheckout != -1) {
      int amountOfDarts = turnsUntilCheckout * 3;
      amountOfDarts += legTurns[turnsUntilCheckout].dartsForCheckout!;

      double average = match.startingScore / amountOfDarts * 3;
      return double.parse(average.toStringAsFixed(2));
    } else {
      for (final turn in legTurns) {
        totalScore += turn.score;
        totalDarts += 3;
      }

      if (totalDarts == 0) {
        return 0.0;
      }

      double average = totalScore / totalDarts * 3;
      return double.parse(average.toStringAsFixed(2));
    }
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
