class RoleAssignmentModel {
  final String id;
  final String avatarUrl;
  final String fullName;
  final Set<String> myRoles;
  final Set<String> allRoles;
  const RoleAssignmentModel(
      this.id, this.avatarUrl, this.fullName, this.myRoles, this.allRoles);

  RoleAssignmentModel.fromJSON(Map<String, dynamic> dataMap)
      : id = dataMap['id'],
        avatarUrl = dataMap['avatar_url'],
        fullName = dataMap['full_name'],
        myRoles = Set<String>.from(dataMap['my_roles']),
        allRoles = Set<String>.from(dataMap['all_roles']);
}
