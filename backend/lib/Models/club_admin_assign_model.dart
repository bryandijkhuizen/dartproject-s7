class ClubAmdminAssingModel{
  final Set<int> clubIds;
  final Set<String> clubNames;
  final int? clubIdUserIsAdmin;
  const ClubAmdminAssingModel(this.clubIds, this.clubNames, this.clubIdUserIsAdmin);

  ClubAmdminAssingModel.fromJSON(Map<String, dynamic> dataMap)
      : clubIdUserIsAdmin = dataMap['admin_club_id'],
        clubIds = Set<int>.from(dataMap['club_ids'] ?? {}),
        clubNames = Set<String>.from(dataMap['club_names'] ??{});
}