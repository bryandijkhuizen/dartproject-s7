class TurnModel {
  final int id;
  final String playerId;
  final int legId;
  final int score;
  final int? doubleAttempts;
  final bool? doubleHit;
  final int? dartsForCheckout;
  final bool isDeadThrow;

  TurnModel({
    required this.id,
    required this.playerId,
    required this.legId,
    required int score,
    this.doubleAttempts,
    this.doubleHit,
    this.dartsForCheckout,
    required this.isDeadThrow,
  }) : score = isDeadThrow
            ? 0
            : score; // [REMOVE WHEN BUSTED SCORES ARE IMPLEMENTED]

  factory TurnModel.fromJson(Map<String, dynamic> json) {
    return TurnModel(
      id: json['id'],
      playerId: json['playerId'],
      legId: json['legId'],
      score: json['score'],
      doubleAttempts: json['doubleAttempts'] ?? 0,
      doubleHit: json['doubleHits'] ?? 0,
      isDeadThrow: json['isDeadThrow'],
      dartsForCheckout: json['dartsForCheckout'] ?? 0,
    );
  }
}
