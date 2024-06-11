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
    // get all sets and calculate the average for each set
    List<double> setAverages =
        setIds.map((setId) => calculateSetAverage(playerId, setId)).toList();

    // filter out the 0.0 averages
    setAverages = setAverages.where((average) => average > 0.0).toList();

    // if there are no averages, return 0.0
    if (setAverages.isEmpty) {
      return 0.0;
    }

    // calculate the average of the averages
    double average = setAverages.reduce((a, b) => a + b) / setAverages.length;

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
    // get all legs for the given set
    List<Map<String, dynamic>> legs = legDataBySet[setId]!;

    // get all leg averages for the given player
    List<double> legAverages =
        legs.map((leg) => calculateLegAverage(playerId, leg['id'])).toList();

    // filter out the 0.0 averages
    legAverages = legAverages.where((average) => average > 0.0).toList();

    // if there are no averages, return 0.0
    if (legAverages.isEmpty) {
      return 0.0;
    }

    double average = legAverages.reduce((a, b) => a + b) / legAverages.length;

    return double.parse(average.toStringAsFixed(2));
  }

  double calculateLegAverage(String playerId, int legId) {
    // get all turns in the leg by the player
    List<TurnModel> playerTurns = turns
        .where((turn) => turn.playerId == playerId && turn.legId == legId)
        .toList();

    int amountOfDarts = 0;
    int totalScore = 0;

    // if there is no double hit in any of the turns
    if (playerTurns.every((turn) => turn.doubleHit == false)) {
      amountOfDarts = playerTurns.length * 3;
      totalScore = playerTurns.fold(0, (sum, turn) => sum + turn.score);
    } else {
      // count the amount of turns
      int turns = playerTurns.length;

      // get the turn in which the double was hit
      TurnModel? checkoutTurn =
          playerTurns.firstWhere((turn) => turn.doubleHit == true);

      // get the dartsForCheckout value
      int dartsForCheckout = checkoutTurn.dartsForCheckout ?? 0;

      // calculate the amount of darts
      amountOfDarts = turns * 3;

      totalScore = match.startingScore;
    }

    if (amountOfDarts == 0) {
      return 0.0;
    }

    double average = totalScore / amountOfDarts * 3;

    return double.parse(average.toStringAsFixed(2));
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
