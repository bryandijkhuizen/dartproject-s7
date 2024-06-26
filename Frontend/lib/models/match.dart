class MatchModel {
  final String id;
  final DateTime date;
  final String? location;
  final int setTarget;
  final int legTarget;
  final int startingScore;
  String? winnerId;
  late String? startingPlayerId;
  late String player1Id;
  late String player2Id;
  late String player1LastName;
  late String player2LastName;
  late bool? isFriendly;

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
      setTarget: json['set_target'],
      legTarget: json['leg_target'],
      startingScore: json['starting_score'],
      winnerId: json['winner_id'] ?? 'Unknown',
      startingPlayerId: json['starting_player_id'] ?? 'Unknown',
      player1LastName: json['player_1_last_name'] ?? 'Unknown',
      player2LastName: json['player_2_last_name'] ?? 'Unknown',
      isFriendly: json['is_friendly'] ?? false,
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
      'starting_player_id': startingPlayerId,
      'is_friendly': isFriendly,
    };
  }
}

class Match {
  late int? id;
  late String? player1Id;
  late String? player2Id;
  final DateTime date;
  late String? location;
  final int setTarget;
  final int legTarget;
  final int startingScore;
  late String? winnerId;
  late String? startingPlayerId;
  late String? player1LastName;
  late String? player2LastName;
  late bool? isFriendly;

  Match({
    this.id,
    this.player1Id,
    this.player2Id,
    required this.date,
    this.location,
    required this.setTarget,
    required this.legTarget,
    required this.startingScore,
    this.winnerId,
    this.startingPlayerId,
    this.player1LastName,
    this.player2LastName,
    this.isFriendly = false,
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'],
      player1Id: json['player_1_id'],
      player2Id: json['player_2_id'],
      date: DateTime.parse(json['date']),
      location: json['location'] ?? 'To be decided',
      setTarget: json['set_target'],
      legTarget: json['leg_target'],
      startingScore: json['starting_score'],
      winnerId: json['winner_id'] ?? '',
      startingPlayerId: json['starting_player_id'] ?? '',
      player1LastName: json['player_1_last_name'] ?? 'To be decided',
      player2LastName: json['player_2_last_name'] ?? 'To be decided',
      isFriendly: json['is_friendly'] ?? false,
    );
  }

  // creates a exact json of the match table in supabase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'player_1_id': player1Id,
      'player_2_id': player2Id,
      'date': date.toIso8601String(),
      'location': location,
      'set_target': setTarget,
      'leg_target': legTarget,
      'starting_score': startingScore,
      'winner_id': winnerId,
      'starting_player_id': startingPlayerId,
      'is_friendly': isFriendly,
    };
  }

  // when inserting a match into the supabase database the names of the parameters may not be the same as collums

  // when inserting a match into the supabase database the names of the parameters may not be the same as columns
  // thats why in this function it returns them with p_ in front of them
  Map<String, dynamic> toInsertableJson() {
    return {
      'p_player_1_id': player1Id,
      'p_player_2_id': player2Id,
      'p_date': date.toIso8601String(),
      'p_location': location,
      'p_set_target': setTarget,
      'p_leg_target': legTarget,
      'p_starting_score': startingScore,
      'p_winner_id': winnerId,
      'p_starting_player_id': startingPlayerId,
      'p_is_friendly': isFriendly,
    };
  }
}
