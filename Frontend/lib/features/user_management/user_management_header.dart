import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/permissions.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementHeader extends StatefulWidget {
  UserManagementHeader(this.supabaseClient,
      {super.key, required this.onSearch}) {
    _searchController = TextEditingController();
  }
  final void Function(String? searchedName, String? searchedRole) onSearch;

  final SupabaseClient supabaseClient;
  late final TextEditingController _searchController;

  @override
  State<UserManagementHeader> createState() => _UserManagementHeaderState();
}

class _UserManagementHeaderState extends State<UserManagementHeader> {
  TextEditingController dropdownController = TextEditingController();

  Future loadRoles(Permissions permission) {
    if (permission.systemPermissions
        .contains(PermissionList.assignRole.permissionName)) {
      return Supabase.instance.client.rpc("get_role_names");
    }
    if (permission.checkClubPermission(PermissionList.assignClubRole)) {
      return Supabase.instance.client.rpc("get_club_role_names");
    }
    return Future(() => null);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    UserStore userStore = context.read();
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text("Select a user", style: theme.textTheme.headlineSmall),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text("Name"),
                      TextField(
                        controller: widget._searchController,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                  future: loadRoles(userStore.permissions),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text(
                            "something went wrong while getting the roles");
                      }
                      if (snapshot.hasData) {
                        List<dynamic> roles = snapshot.data as List<
                            dynamic>; // Assuming the data is a list of roles

                        List<DropdownMenuEntry<dynamic>> dropdownMenuEntries =
                            roles.map((role) {
                          return DropdownMenuEntry<dynamic>(
                            value: role["role_name"].toString(),
                            label: role["role_name"].toString(),
                          );
                        }).toList();

                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text("Role"),
                              DropdownMenu(
                                controller: dropdownController,
                                dropdownMenuEntries: dropdownMenuEntries,
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return const CircularProgressIndicator();
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () {
                    // Get the search term from the text field
                    String searchedName = widget._searchController.text;
                    // Trigger the callback with the search term
                    widget.onSearch(searchedName, dropdownController.text);
                  },
                  child: const Text("Search"),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }
}
