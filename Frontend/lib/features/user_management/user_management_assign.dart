import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementAssign extends StatefulWidget {
  UserManagementAssign({Key? key, required this.uuid}) : super(key: key);

  final String uuid;

  @override
  _UserManagementAssignState createState() => _UserManagementAssignState();
}

class _UserManagementAssignState extends State<UserManagementAssign> {
  late final Future<rol_assignment_model> fetchCurrentUsersRoleFuture;
  void initState() {
    fetchCurrentUsersRoleFuture = Supabase.instance.client.rpc(
        "get_current_user_roles",
        params: {'current_user_id': '${widget.uuid}'});
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
                future: fetchCurrentUsersRoleFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Text("something went wrong");
                  }
                  if (snapshot.hasData) {
                    var userdata = snapshot.data[0];
                    print(snapshot.data);

                    return Column(
                      children: [
                        DataTable(
                          showCheckboxColumn: true,
                          headingRowColor:
                              MaterialStatePropertyAll(theme.colorScheme.primary),
                          headingTextStyle: const TextStyle(color: Colors.white),
                          columnSpacing: 10,
                          columns: const [
                            DataColumn(
                              label: Text('Role'),
                            ),
                          ],
                          rows: [
                            for (var roles in userdata["all_roles"])
                              DataRow(
                                color:
                                    MaterialStatePropertyAll(Colors.grey.shade300),
                                onSelectChanged: (value){print("jo");},
                                cells: [
                                  DataCell(
                                    Text(roles.toString(),
                                        style: TextStyle(color: Colors.black)),
                                  ),
                                 
                                ],
                              ),
                          ],
                        ),
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
