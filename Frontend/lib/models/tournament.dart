enum StartingMethod {
  bulloff,
  random,
}

class TournamentModel {
  final int? id;
  final String name;
  final String location;
  final DateTime startTime;
  final String? clubId;
  final StartingMethod startingMethod;

  TournamentModel({
    required this.id,
    required this.name,
    required this.location,
    required this.startTime,
    this.clubId,
    required this.startingMethod,
  });

  factory TournamentModel.fromJson(Map<String, dynamic> json) {
    return TournamentModel(
      id: json['id'],
      name: json['name'],
      location: json['location'],
      startTime: DateTime.parse(json['start_time']),
      clubId: json['club_id'],
      startingMethod: json['starting_method'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'location': location,
      'start_time': startTime.toIso8601String(),
      'club_id': clubId,
      'starting_method': startingMethod.name,
    };
  }
}
