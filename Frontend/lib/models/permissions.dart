import 'package:darts_application/models/permission_list.dart';

class Permissions {
  List<String> systemPermissions;
  Map<int, List<String>> clubPermissions;

  Permissions(this.systemPermissions, this.clubPermissions);

  bool checkClubPermission(PermissionList permission){
    return clubPermissions.entries.where((club) => club.value.contains(permission.permissionName)).isNotEmpty;
  }

  int getClubIdByPermission(PermissionList permission){
    return clubPermissions.keys.firstWhere((key) => clubPermissions[key]?.contains(permission.permissionName) ?? false, orElse: () => -1,);
  }

  bool chechClubManagmentRole(){
    var perm = clubPermissions;
    var perm2 = systemPermissions;
    return perm.entries.where((club) => club.value.contains(PermissionList.manageClubMembers.permissionName)).isNotEmpty;
  }
}