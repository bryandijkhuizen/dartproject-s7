class TurnModel {
  final int id;
  final String playerId;
  final int legId;
  final int score;
  final int? doubleAttempts;
  final int? doubleHits;
  final bool isDeadThrow;

  TurnModel({
    required this.id,
    required this.playerId,
    required this.legId,
    required this.score,
    this.doubleAttempts,
    this.doubleHits,
    required this.isDeadThrow,
  });

  factory TurnModel.fromJson(Map<String, dynamic> json) {
    return TurnModel(
      id: json['id'],
      playerId: json['playerId'],
      legId: json['legId'],
      score: json['score'],
      doubleAttempts: json['doubleAttempts'] ?? 0,
      doubleHits: json['doubleHits'] ?? 0,
      isDeadThrow: json['isDeadThrow'],
    );
  }
}
