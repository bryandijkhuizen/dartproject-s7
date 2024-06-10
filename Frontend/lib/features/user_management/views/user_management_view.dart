import 'package:darts_application/features/user_management/user_management_header.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/permissions.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({super.key});

  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  String? name;
  String? role;
  Future loadUsersData(UserStore store) {
    Permissions permission = store.permissions;
    String currentUserId = store.currentSession!.user.id;
    if(permission.systemPermissions.contains(PermissionList.assignRole.permissionName)){
      return Supabase.instance.client.rpc("get_all_users_and_roles", params: {'name_filter': name, 'role_filter': role, 'current_user_id': currentUserId },);
    }
    if(permission.checkClubPermission(PermissionList.assignClubRole)){
      int clubId = permission.getClubIdByPermission(PermissionList.assignClubRole);
      return Supabase.instance.client.rpc("get_all_users_and_clubroles", params: {'name_filter': name, 'role_filter': role, 'club_id': clubId, 'current_user_id': currentUserId},);
    }
    return Future(() => null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    UserStore userStore = context.read();
    return Center(
      child: Container(
        constraints: const BoxConstraints(maxWidth: 800),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            UserManagementHeader(
              Supabase.instance.client,
              onSearch: (String? searchedName, String? searchedRole) {
                setState(() {
                  // Update the search filter
                  name = searchedName;
                  role = searchedRole;
                });
              },
            ),
            FutureBuilder(
              future: loadUsersData(userStore),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text("something went wrong");
                  }
                  if (snapshot.hasData) {
                    return DataTable(
                      headingRowColor:
                          WidgetStatePropertyAll(theme.colorScheme.primary),
                      headingTextStyle: const TextStyle(color: Colors.white),
                      columnSpacing: 100,
                      columns: const [
                        DataColumn(
                          label: Text('Name'),
                        ),
                        DataColumn(
                          label: Text('Roles'),
                        ),
                        DataColumn(
                          label: Text(""),
                          numeric: true,
                        ),
                      ],
                      rows: [
                        for (var userObj in snapshot.data)
                          DataRow(
                            color:
                                WidgetStatePropertyAll(Colors.grey.shade300),
                            cells: [
                              DataCell(
                                Text(userObj["full_name"],
                                    style: const TextStyle(color: Colors.black)),
                              ),
                              DataCell(
                                Text(userObj["roles"].toString(),
                                    style: const TextStyle(color: Colors.black)),
                              ),
                              DataCell(
                                FilledButton(
                                  onPressed: () {
                                    context.go(
                                        "/user-management/edit/${userObj["id"]}");
                                  },
                                  child: const Text("Edit"),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                }
                return const CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
