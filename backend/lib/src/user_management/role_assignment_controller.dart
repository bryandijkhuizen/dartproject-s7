import 'package:backend/Models/club_admin_assign_model.dart';
import 'package:backend/backend.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';

class RoleAssignmentController {
  Future<RoleAssignmentModel> model;
  Future<ClubAmdminAssingModel> clubAdminAssignModel;

  final SupabaseClient supabaseClient;
  int adminClubId = 0;
  Set<String> selectedList = {};
  bool isClubAdministrator = false;
  int clubId = 0;

  RoleAssignmentController(
      this.supabaseClient, this.isClubAdministrator, this.clubId, String id)
      : model = _fetchCurrentUserRoles(id, isClubAdministrator, clubId),
        clubAdminAssignModel = _fetchClubAdminModel(id, isClubAdministrator);

  static Future<RoleAssignmentModel> _fetchCurrentUserRoles(
      String id, bool isClubAdministrator, int clubId) async {
    Map<String, dynamic> dataMap = {};

    if (isClubAdministrator) {
      final response = await Supabase.instance.client.rpc(
        "get_current_user_and_clubrole_information",
        params: {'current_user_id': id, 'current_club_id': clubId},
      );
      dataMap = response[0] as Map<String, dynamic>;
    } else {
      final response = await Supabase.instance.client.rpc(
        "get_current_user_and_role_information",
        params: {'current_user_id': id},
      );
      dataMap = response[0] as Map<String, dynamic>;
    }

    return RoleAssignmentModel.fromJSON(dataMap);
  }

  static Future<ClubAmdminAssingModel> _fetchClubAdminModel(
      String id, bool isClubAdministrator) async {
    Map<String, dynamic> dataMap = {};

    if (isClubAdministrator) {
      return ClubAmdminAssingModel({}, {}, null);
    } else {
      final response = await Supabase.instance.client.rpc(
        "get_user_clubs_and_admin_roles",
        params: {'current_user_id': id},
      );
      dataMap = response[0] as Map<String, dynamic>;
    }

    return ClubAmdminAssingModel.fromJSON(dataMap);
  }

  List<DropdownMenuEntry<dynamic>> getClubsDropdown(ClubAmdminAssingModel model) {
    List<DropdownMenuEntry<dynamic>> dropdownMenuEntries = [];
    dropdownMenuEntries.add(DropdownMenuEntry(value: 0, label: 'Geen'));
    for(int i =0; i< model.clubNames.length; i++){
      dropdownMenuEntries.add(DropdownMenuEntry(value: model.clubIds.elementAt(i), label: model.clubNames.elementAt(i)));
    }
    return dropdownMenuEntries;
  }

  DropdownMenuEntry<dynamic> getInitialDropDown(ClubAmdminAssingModel model) {
    DropdownMenuEntry initialEntry = DropdownMenuEntry(value: 0, label: 'Geen');
    for(int i =0; i< model.clubNames.length; i++){
      if(model.clubIds.elementAt(i) == model.clubIdUserIsAdmin){
        initialEntry = DropdownMenuEntry(value: model.clubIds.elementAt(i), label: model.clubNames.elementAt(i));
      }
    }
    return initialEntry;
  }

  void setAdminClubId(int modelClubId){
    if(adminClubId == 0){
      adminClubId = modelClubId;
    }
  }

  void updateAdminClubId(int modelClubId){
    adminClubId = modelClubId;
  }

  void setSelectlist(Set<String> currentUserRoles) {
    if (selectedList.isEmpty) {
      selectedList = Set.from(currentUserRoles);
    }
  }

  Set<String> getSelectlist() {
    return selectedList;
  }

  void addRole(String role) {
    selectedList.add(role);
  }

  void removeRole(String role) {
    selectedList.remove(role);
  }

  Future<void> saveRoles(Set<String> currentUserRoles, String id) async {
    List<String> removalDifference =
        currentUserRoles.difference(selectedList).toList();
    List<String> addedDifference =
        selectedList.difference(currentUserRoles).toList();

    if (removalDifference.isNotEmpty) {
      if (isClubAdministrator) {
        await Supabase.instance.client.rpc(
          "delete_user_clubroles",
          params: {
            'current_user_id': id,
            'role_names': removalDifference,
            'current_club_id': clubId
          },
        );
      } else {
        await Supabase.instance.client.rpc(
          "delete_user_roles",
          params: {'current_user_id': id, 'role_names': removalDifference},
        );
      }
    }

    if (addedDifference.isNotEmpty) {
      if (isClubAdministrator) {
        await Supabase.instance.client.rpc(
          "add_user_clubroles",
          params: {
            'current_user_id': id,
            'role_names': addedDifference,
            'current_club_id': clubId
          },
        );
      } else {
        await Supabase.instance.client.rpc(
          "add_user_roles",
          params: {'current_user_id': id, 'role_names': addedDifference},
        );
      }
    }
  }
  Future<void> saveClubAdminRole(String id) async{
      await Supabase.instance.client.rpc(
          "update_club_administrator",
          params: {'current_user_id': id, 'new_club_id': adminClubId},
        );
  }
}
