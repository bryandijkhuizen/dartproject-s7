class MatchModel {
  final String id;
  final String player1Id;
  final String player2Id;
  final DateTime date;
  final String? location;
  final int setTarget;
  final int legTarget;
  final int startingScore;
  final String? winnerId;
  late String? startingPlayerId;
  late String player1LastName;
  late String player2LastName;
  late bool isFriendly;

  MatchModel({
    required this.id,
    required this.player1Id,
    required this.player2Id,
    required this.date,
    this.location,
    required this.setTarget,
    required this.legTarget,
    required this.startingScore,
    this.winnerId,
    this.startingPlayerId,
    required this.player1LastName,
    required this.player2LastName,
    this.isFriendly = false,
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'].toString(),
      player1Id: json['player_1_id'].toString(),
      player2Id: json['player_2_id'].toString(),
      date: DateTime.parse(json['date']),
      location: json['location'] ?? 'Unknown',
      isFriendly: json['is_friendly'] ?? false,
      setTarget: json['set_target'],
      legTarget: json['leg_target'],
      startingScore: json['starting_score'],
      winnerId: json['winner_id'] ?? 'Unknown',
      startingPlayerId: json['starting_player_id'] ?? 'Unknown',
      player1LastName: json['player_1_last_name'] ?? 'Unknown',
      player2LastName: json['player_2_last_name'] ?? 'Unknown',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'player_1_id': player1Id,
      'player_2_id': player2Id,
      'date': date.toIso8601String(),
      'location': location,
      'set_target': setTarget,
      'leg_target': legTarget,
      'starting_score': startingScore,
      'winner_id': winnerId,
      'starting_player_id': startingPlayerId
    };
  }
}
