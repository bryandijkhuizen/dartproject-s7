class TournamentRounds {
  List<Round> rounds = [];

  TournamentRounds({required this.rounds});

  TournamentRounds.fromJson(List<dynamic> dataMap)
      : rounds = sortRounds(dataMap);

  static List<Round> sortRounds(List<dynamic> dataMap) {
    List<Round> allRounds = [];

    for (var match in dataMap) {
      int roundNumber = match['round_number'];
      if (allRounds.length < roundNumber) {
        allRounds.add(Round(roundNumber: roundNumber, roundHeader: "Round: ${roundNumber}", matches: [match]));
      } else {
        allRounds[roundNumber - 1].addMatch(match);
      }
    }
    if(allRounds.length >= 1 ){
      allRounds.last.roundHeader = "Finals";
    }
    if(allRounds.length >= 2 ){
      allRounds[allRounds.length -2].roundHeader = "Semi Finals";
    }
    return allRounds;
  }
}

class Round{
  String roundHeader;
  int roundNumber;
  List<Map<String, dynamic>> matches;

  Round({required this.roundNumber, required this.roundHeader, required this.matches});

  void addMatch(Map<String, dynamic> match){
    matches.add(match);
  }
}
