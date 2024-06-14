import 'package:darts_application/models/match.dart';

class Tournament {
  List<TournamentRound> rounds = [];

  Tournament({required this.rounds});

  Tournament.fromJson(List<dynamic> dataMap) : rounds = sortRounds(dataMap);

  static List<TournamentRound> sortRounds(List<dynamic> dataMap) {
    List<TournamentRound> allRounds = [];

    for (var match in dataMap) {
      int roundNumber = match['round_number'];
      if (allRounds.length < roundNumber) {
        allRounds.add(TournamentRound(
            roundNumber: roundNumber,
            roundHeader: "Round: ${roundNumber}",
            matches: [Match.fromJson(match)]));
      } else {
        allRounds[roundNumber - 1].addMatch(match);
      }
    }
    if (allRounds.length >= 1) {
      allRounds.last.roundHeader = "Finals";
    }
    if (allRounds.length >= 2) {
      allRounds[allRounds.length - 2].roundHeader = "Semi Finals";
    }
    return allRounds;
  }
}

class TournamentRound {
  String roundHeader;
  int roundNumber;
  List<Match> matches;

  TournamentRound(
      {required this.roundNumber,
      required this.roundHeader,
      required this.matches});

  void addMatch(Map<String, dynamic> datamap) {
    matches.add(Match.fromJson(datamap));
  }
}
