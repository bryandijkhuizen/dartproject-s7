class PlayerModel {
  final String id;
  final String firstName;
  final String lastName;
  final String avatarId;

  PlayerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.avatarId,
  });

  String get fullName => "$firstName $lastName";

  factory PlayerModel.fromJson(Map<String, dynamic> json) {
    return PlayerModel(
      id: json['id'].toString(),
      firstName: json['first_name'].toString(),
      lastName: json['last_name'].toString(),
      avatarId: json['avatar_id'].toString(),
    );
  }

  factory PlayerModel.placeholderPlayer({
    String id = "",
    String firstName = "",
    String lastName = "",
    String avatarId = "1",
  }) {
    return PlayerModel(
        id: id, firstName: firstName, lastName: lastName, avatarId: avatarId);
  }
}
