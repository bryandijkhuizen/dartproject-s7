import 'package:darts_application/features/club_management/views/current_members_manager_view.dart';
import 'package:darts_application/features/club_management/views/edit_club_info_view.dart';
import 'package:darts_application/features/club_management/views/new_members_manager_view.dart';
import 'package:flutter/material.dart';

class ClubManagement extends StatefulWidget {
  const ClubManagement({ Key? key }) : super(key: key);

  @override
  _ClubManagementState createState() => _ClubManagementState();
}

class _ClubManagementState extends State<ClubManagement> {
  @override
  Widget build(BuildContext context) {
    return const Center(
      child: SingleChildScrollView(child: Column(children: [CurrentMembersManagerView(), NewMembersManagerView(), EditClubInfoView()],)),
    );
  }
}