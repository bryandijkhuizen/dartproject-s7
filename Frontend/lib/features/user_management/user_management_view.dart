import 'package:darts_application/features/user_management/user_management_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
  late final Future<dynamic> fetchAllUserFuture;
  @override
  void initState() {
    fetchAllUserFuture = Supabase.instance.client.rpc("get_all_users");
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
            const UserManagementHeader(),
            FutureBuilder(
              future: fetchAllUserFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text("something went wrong");
                  }
                  if (snapshot.hasData) {
                    print(snapshot.data);

                    return DataTable(
                      headingRowColor:
                          MaterialStatePropertyAll(theme.colorScheme.primary),
                      headingTextStyle: const TextStyle(color: Colors.white),
                      columnSpacing: 10,
                      columns: const [
                        DataColumn(
                          label: Text('Name'),
                        ),
                        DataColumn(
                          label: Text('Role'),
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
                                MaterialStatePropertyAll(Colors.grey.shade300),
                            cells: [
                              DataCell(
                                Text( userObj["full_name"],style: TextStyle(color: Colors.black)),
                              ),
                              DataCell(
                                Text(userObj["roles"].toString(), style: TextStyle(color: Colors.black)),
                              ),
                              DataCell(
                                FilledButton(
                                  onPressed: () {context.go("/user-management/edit/${userObj["id"]}");},
                                  child: const Text("Edit"),
                                ),
                              ),
                            ],
                          ),
                      ],
                    );
                  }
                }
                return CircularProgressIndicator();
              },
            ),
          ],
        ),
      ),
    );
  }
}
