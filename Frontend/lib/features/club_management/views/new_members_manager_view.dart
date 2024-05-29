import 'package:darts_application/features/club_management/members_manager.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class NewMembersManagerView extends StatefulWidget {
  const NewMembersManagerView({Key? key}) : super(key: key);

  @override
  _NewMembersManagerViewState createState() => _NewMembersManagerViewState();
}

class _NewMembersManagerViewState extends State<NewMembersManagerView> {
  late MembersManager manager;

  void loadData() {
    UserStore userStore = context.read();
    int clubId = userStore.permissions
        .getClubIdByPermission(PermissionList.manageClubMembers);
    manager = MembersManager(Supabase.instance.client, clubId);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    loadData();
    return FutureBuilder(
      future: manager.newmembers,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('something went wrong');
        }

        if (snapshot.hasData) {
          Map<String, String> memberlist = snapshot.data!;

          return Stack(children: [
            DataTable(
              headingRowColor:
                  WidgetStateProperty.all(theme.colorScheme.primary),
              headingTextStyle: const TextStyle(color: Colors.white),
              columnSpacing: 10,
              columns: const [
                DataColumn(
                  label: Text('Name'),
                ),
                DataColumn(
                  label: Text(''),
                ),
                DataColumn(label: Text("")),
              ],
              rows: [
                for (MapEntry<String, String> member in memberlist.entries)
                  DataRow(
                    color: WidgetStateProperty.all(Colors.grey.shade300),
                    cells: [
                      DataCell(
                        Text(member.value,
                            style: const TextStyle(color: Colors.black)),
                      ),
                      DataCell(
                        FilledButton(
                          onPressed: () async {
                            await Supabase.instance.client
                                .rpc("approve_user_from_club", params: {
                              'current_user_id': member.key,
                              'current_club_id': manager.clubId
                            });
                            setState(() {});
                          },
                          style: ButtonStyle(
                              backgroundColor:
                                  WidgetStatePropertyAll(Colors.green.shade700)),
                          child: const Text('Accept'),
                        ),
                      ),
                      DataCell(FilledButton(
                        onPressed: () async {
                          // show the AlertDialog
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text("Notice",
                                    style: TextStyle(color: Colors.black)),
                                content: const Text(
                                  "Are you sure you want to reject this member?",
                                  style: TextStyle(color: Colors.black),
                                ),
                                actions: [
                                  FilledButton(
                                    child: const Text("Confirm"),
                                    onPressed: () async {
                                      await Supabase.instance.client.rpc(
                                          "delete_user_from_club",
                                          params: {
                                            'current_user_id': member.key,
                                            'current_club_id': manager.clubId
                                          });
                                      Navigator.of(context).pop();
                                      setState(() {});
                                    },
                                  ),
                                  FilledButton(
                                    child: const Text("Cancel"),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        },
                        child: const Text('Reject'),
                      )),
                    ],
                  ),
              ],
            ),
            Positioned(
              top: 8,
              right: 8,
              child: IconButton(
                onPressed: () {
                  setState(() {});
                },
                icon: Icon(
                  Icons.refresh,
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ]);
        }
        return const CircularProgressIndicator();
      },
    );
  }
}
