import 'package:backend/Models/club_admin_assign_model.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:backend/backend.dart';

class UserManagementAssignView extends StatefulWidget {
  const UserManagementAssignView({super.key, required this.uuid});

  final String uuid;

  @override
  _UserManagementAssignViewState createState() =>
      _UserManagementAssignViewState();
}

class _UserManagementAssignViewState extends State<UserManagementAssignView> {
  late RoleAssignmentController controller;
  @override
  void initState() {
    UserStore userStore = context.read();
    bool isClubAdmin = userStore.permissions
        .checkClubPermission(PermissionList.assignClubRole);
    int clubId = userStore.permissions
        .getClubIdByPermission(PermissionList.assignClubRole);
    controller = RoleAssignmentController(
        Supabase.instance.client, isClubAdmin, clubId, widget.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FutureBuilder(
                  future: controller.model,
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return const Text('something went wrong');
                    }
                    if (snapshot.hasData) {
                      var userData = snapshot.data;
                      controller.setSelectlist(userData!.myRoles);
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(30.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: CircleAvatar(
                                    radius: 50,
                                    backgroundImage:
                                        NetworkImage(userData.avatarUrl),
                                  ),
                                ),
                                Text(
                                  userData.fullName,
                                  style: theme.textTheme.headlineSmall,
                                ),
                              ],
                            ),
                          ),
                          DataTable(
                            showCheckboxColumn: true,
                            headingRowColor: WidgetStatePropertyAll(
                                theme.colorScheme.primary),
                            headingTextStyle:
                                const TextStyle(color: Colors.white),
                            columnSpacing: 10,
                            columns: const [
                              DataColumn(
                                label: Text('Role'),
                              ),
                            ],
                            rows: [
                              for (var role in userData.allRoles)
                                DataRow(
                                  color: WidgetStatePropertyAll(
                                      Colors.grey.shade300),
                                  onSelectChanged: (value) {
                                    if (value == true) {
                                      setState(() {
                                        controller.addRole(role);
                                      });
                                    } else if (value == false) {
                                      setState(() {
                                        controller.removeRole(role);
                                      });
                                    }
                                  },
                                  selected:
                                      controller.getSelectlist().contains(role),
                                  cells: [
                                    DataCell(
                                      Text(role.toString(),
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    ),
                                  ],
                                ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 8),
                            child: FutureBuilder(
                                future: controller.clubAdminAssignModel,
                                builder: (context, snapshot) {
                                  if (!controller.isClubAdministrator) {
                                    if (snapshot.hasError) {
                                      return const Text('something went wrong');
                                    }
                                    if (snapshot.hasData) {
                                      ClubAmdminAssingModel clubAdminModel =
                                          snapshot.data!;
                                      controller.setAdminClubId(
                                          clubAdminModel.clubIdUserIsAdmin ??
                                              0);
                                      return Container(
                                        constraints:
                                            const BoxConstraints(minWidth: 600),
                                        child: DataTable(
                                          headingRowColor:
                                              WidgetStatePropertyAll(
                                                  theme.colorScheme.primary),
                                          headingTextStyle: const TextStyle(
                                              color: Colors.white),
                                          columnSpacing: 10,
                                          columns: const [
                                            DataColumn(
                                              label: Text('Role'),
                                            ),
                                            DataColumn(
                                              label: Text('club'),
                                            )
                                          ],
                                          rows: [
                                            DataRow(
                                              color: WidgetStatePropertyAll(
                                                  Colors.grey.shade300),
                                              cells: [
                                                const DataCell(
                                                  Text('Club administrator',
                                                      style: TextStyle(
                                                          color: Colors.black)),
                                                ),
                                                DataCell(DropdownMenu(
                                                  dropdownMenuEntries:
                                                      controller
                                                          .getClubsDropdown(
                                                              clubAdminModel),
                                                  initialSelection:
                                                      clubAdminModel
                                                          .clubIdUserIsAdmin,
                                                  textStyle: const TextStyle(
                                                      color: Colors.black),
                                                  onSelected: (value) =>
                                                      controller
                                                          .updateAdminClubId(
                                                              value),
                                                ))
                                              ],
                                            ),
                                          ],
                                        ),
                                      );
                                    }
                                    return const CircularProgressIndicator();
                                  } else {
                                    return Container();
                                  }
                                }),
                          ),
                          Row(
                            children: [
                              FilledButton(
                                  onPressed: () {
                                    context.goBack("/user-management");
                                  },
                                  child: const Text("Cancel")),
                              FilledButton(
                                  onPressed: () {
                                    controller.saveRoles(
                                        userData.myRoles, userData.id);
                                    if (!controller.isClubAdministrator) {
                                      controller.saveClubAdminRole(userData.id);
                                    }
                                    Future.delayed(
                                        const Duration(milliseconds: 500), () {
                                      context.goBack("/user-management");
                                    });
                                  },
                                  child: const Text("Save")),
                            ],
                          )
                        ],
                      );
                    }
                    return const CircularProgressIndicator();
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
