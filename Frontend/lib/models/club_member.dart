class ClubMember {
  final String userId;
  final String lastName;
  final int clubId;
  final String clubName;

  ClubMember({
    required this.userId,
    required this.lastName,
    required this.clubId,
    required this.clubName,
  });

  factory ClubMember.fromJson(Map<String, dynamic> json) {
    return ClubMember(
      userId: json['user_id'],
      lastName: json['last_name'] ?? 'Unknown',
      clubId: json['club_id'],
      clubName: json['club_name'] ?? 'Unknown',
    );
  }
}
