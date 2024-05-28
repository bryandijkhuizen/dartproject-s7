import 'package:darts_application/features/club_management/members_manager.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class CurrentMembersManagerView extends StatefulWidget {
  const CurrentMembersManagerView({Key? key}) : super(key: key);

  @override
  _CurrentMembersManagerViewState createState() =>
      _CurrentMembersManagerViewState();
}

class _CurrentMembersManagerViewState extends State<CurrentMembersManagerView> {
  late MembersManager manager;
  @override
  void initState() {
    UserStore userStore = context.read();
    int clubId = userStore.permissions
        .getClubIdByPermission(PermissionList.manageClubMembers);
    manager = MembersManager(Supabase.instance.client, clubId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return FutureBuilder(
        future: manager.members,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Text('something went wrong');
          }
          if (snapshot.hasData) {
            Map<String, String> memberlist = snapshot.data!;
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
                  label: Text(''),
                ),
              ],
              rows: [
                for (MapEntry<String, String> member in memberlist.entries)
                  DataRow(
                    color: MaterialStatePropertyAll(Colors.grey.shade300),
                    cells: [
                      DataCell(
                        Text(member.value, style: TextStyle(color: Colors.black)),
                      ),
                      DataCell(FilledButton(
                          onPressed: () {
                            print("monkey");
                          },
                          child: const Text('Remove')))
                    ],
                  ),
              ],
            );
          }
          return const CircularProgressIndicator();
        });
  }
}
