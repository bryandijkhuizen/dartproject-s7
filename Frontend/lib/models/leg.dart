class LegModel {
  final int id;
  final String winnerId;
  final int setId;

  LegModel({
    required this.id,
    required this.winnerId,
    required this.setId,
  });

  factory LegModel.fromJson(Map<String, dynamic> json) {
    return LegModel(
      id: json['id'],
      winnerId: json['winnerId'],
      setId: json['setId'],
    );
  }
}
