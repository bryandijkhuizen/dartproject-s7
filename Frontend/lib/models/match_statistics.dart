import 'package:darts_application/models/leg.dart';
import 'package:darts_application/models/set.dart';
import 'package:darts_application/models/turn.dart';

class MatchStatisticsModel {
  final List<TurnModel> turns;

  MatchStatisticsModel({required this.turns});

  // calculate the average score of a player
  double calculateAverageScore(playerId) {
    // first get all the scores of the turns with the given playerId
    List<int> scores = turns
        .where((turn) => turn.playerId == playerId)
        .map((turn) => turn.score)
        .toList();

    // then calculate the average
    double average = scores.reduce((a, b) => a + b) / scores.length;

    return average;
  }
}
