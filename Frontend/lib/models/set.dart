class SetModel {
  final int id;
  final String winnerId;
  final int matchId;

  SetModel({
    required this.id,
    required this.winnerId,
    required this.matchId,
  });

  factory SetModel.fromJson(Map<String, dynamic> json) {
    return SetModel(
      id: json['id'],
      winnerId: json['winnerId'],
      matchId: json['matchId'],
    );
  }
}
