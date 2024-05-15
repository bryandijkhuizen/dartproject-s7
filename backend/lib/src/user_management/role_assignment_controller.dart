import 'package:backend/backend.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class RoleAssignmentController {
  Future<RoleAssignmentModel> model;

  final SupabaseClient supabaseClient;
  Set<String> selectedList = {};

  RoleAssignmentController(this.supabaseClient, String id)
      : model = _fetchCurrentUserRoles(id);

  static Future<RoleAssignmentModel> _fetchCurrentUserRoles(String id) async {
    final response = await Supabase.instance.client.rpc(
      "get_current_user_and_role_information",
      params: {'current_user_id': id},
    );

    var dataMap = response[0] as Map<String, dynamic>;
    return RoleAssignmentModel.fromJSON(dataMap);
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
      await Supabase.instance.client.rpc(
        "delete_user_roles",
        params: {'current_user_id': id, 'role_names': removalDifference},
      );
    }

    if (addedDifference.isNotEmpty){
       await Supabase.instance.client.rpc(
        "add_user_roles",
        params: {'current_user_id': id, 'role_names': addedDifference},
      );
    }
  }
}
