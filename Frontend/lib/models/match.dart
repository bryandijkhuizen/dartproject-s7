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
  final String? startingPlayerId;
  late String player1LastName;
  late String player2LastName;

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
  });

  factory MatchModel.fromJson(Map<String, dynamic> json) {
    return MatchModel(
      id: json['id'].toString(),
      player1Id: json['player_1_id'].toString(),
      player2Id: json['player_2_id'].toString(),
      date: DateTime.parse(json['date']),
      location: json['location'] ?? 'Unknown',
      setTarget: json['set_target'],
      legTarget: json['leg_target'],
      startingScore: json['starting_score'],
      winnerId: json['winner_id'] ?? 'Unknown',
      startingPlayerId: json['starting_player_id'] ?? 'Unknown',
      player1LastName: json['player_1_last_name'] ?? 'Unknown',
      player2LastName: json['player_2_last_name'] ?? 'Unknown',
    );
  }
}
