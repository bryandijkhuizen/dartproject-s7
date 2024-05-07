import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementHeader extends StatelessWidget {
  UserManagementHeader(this.supabaseClient, {Key? key, required this.onSearch})
      : super(key: key) {
    _searchController = TextEditingController();
  }
  final void Function(String? searchedName,String? searchedRole ) onSearch;

  
  final SupabaseClient supabaseClient;
  String? selectedRole;
  late TextEditingController _searchController;
  Future loadRoles() {
    return Supabase.instance.client.rpc("get_role_names");
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
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
                      Text("Name"),
                      TextField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter a search term',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              FutureBuilder(
                  future: loadRoles(),
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
                            value:
                                role["role_name"].toString(), // Assuming roles are strings
                            label: role["role_name"].toString(),
                          );
                        }).toList();

                        return Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("Role"),
                              DropdownMenu(
                                onSelected: (value) {
                                  selectedRole = value;
                                },
                                dropdownMenuEntries: dropdownMenuEntries,
                              ),
                            ],
                          ),
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: FilledButton(
                  onPressed: () {
                    // Get the search term from the text field
                    String searchedName = _searchController.text;
                  // Trigger the callback with the search term
                    onSearch(searchedName, selectedRole);
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
