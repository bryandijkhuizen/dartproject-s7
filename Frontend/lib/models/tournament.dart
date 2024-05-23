class TournamentModel {
  final String id;
  final String name;
  final String location;
  final DateTime startTime;
  final String? clubId;
  final Enum startingMethod;

  TournamentModel({
    required this.id,
    required this.name,
    required this.location,
    required this.startTime,
    this.clubId,
    required this.startingMethod
  });
}