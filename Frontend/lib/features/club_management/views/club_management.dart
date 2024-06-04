import 'package:darts_application/features/club_management/views/current_club_manager_view.dart';
import 'package:darts_application/features/club_management/views/new_club_management_view.dart';
import 'package:flutter/material.dart';

class ClubManagement extends StatefulWidget {
  const ClubManagement({Key? key}) : super(key: key);

  @override
  _ClubManagementState createState() => _ClubManagementState();
}

class _ClubManagementState extends State<ClubManagement> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
      children: [Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text("Manage new and current clubs", style: theme.textTheme.headlineSmall),
      ),const Padding(
        padding: EdgeInsets.all(8.0),
        child: NewClubManagerView(),
      ), const Padding(
        padding: EdgeInsets.all(8.0),
        child: CurrentClubManagerView(),
      )],
    ));
  }
}
