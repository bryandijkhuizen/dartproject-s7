import 'package:darts_application/features/app_router/app_router_extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:backend/backend.dart';

class UserManagementAssignView extends StatefulWidget {
  UserManagementAssignView({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  _UserManagementAssignViewState createState() => _UserManagementAssignViewState();
}

class _UserManagementAssignViewState extends State<UserManagementAssignView> {
  late RoleAssignmentController controller;
  @override
  void initState() {
    controller =
        RoleAssignmentController(Supabase.instance.client, widget.uuid);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Center(
      child: Container(
        constraints: BoxConstraints(maxWidth: 600),
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
                                      NetworkImage(userData!.avatarUrl),
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
                          headingRowColor: MaterialStatePropertyAll(
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
                                color: MaterialStatePropertyAll(
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
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                ],
                              ),
                          ],
                        ),
                        Row(
                          children: [
                            FilledButton(
                                onPressed: () {
                                  context.goBack("/user-management");
                                },
                                child: Text("Cancel")),
                            FilledButton(
                                onPressed: () {
                                  controller.saveRoles(
                                      userData.myRoles, userData.id);
                                  Future.delayed(
                                      const Duration(milliseconds: 500), () {
                                    context.goBack("/user-management");
                                  });
                                },
                                child: Text("Save")),
                          ],
                        )
                      ],
                    );
                  }
                  return CircularProgressIndicator();
                }),
          ],
        ),
      ),
    );
  }
}
