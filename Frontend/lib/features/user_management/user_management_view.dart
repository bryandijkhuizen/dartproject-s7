import 'package:darts_application/features/user_management/user_management_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UserManagementView extends StatefulWidget {
  const UserManagementView({Key? key}) : super(key: key);

  @override
  _UserManagementViewState createState() => _UserManagementViewState();
}

class _UserManagementViewState extends State<UserManagementView> {
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
            DataTable(
              headingRowColor: MaterialStatePropertyAll(theme.colorScheme.primary),
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
                DataRow(
                  color: MaterialStatePropertyAll(Colors.grey.shade300),
                  cells: [
                    DataCell(
                      Text('Kevin'),
                    ),
                    DataCell(
                      Text('een rol'),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {},
                        child: const Text("Edit"),
                      ),
                    ),
                  ],
                ),
                DataRow(
                  color: MaterialStatePropertyAll(Colors.grey.shade100),
                  cells: [
                    DataCell(
                      Text('Kevin'),
                    ),
                    DataCell(
                      Text('een rol'),
                    ),
                    DataCell(
                      TextButton(
                        onPressed: () {},
                        child: const Text("Edit"),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
