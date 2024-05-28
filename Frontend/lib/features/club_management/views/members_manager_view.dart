import 'package:darts_application/features/club_management/members_manager.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageMembersView extends StatefulWidget {
  const ManageMembersView({ Key? key }) : super(key: key);

  @override
  _ManageMembersViewState createState() => _ManageMembersViewState();
 
}

class _ManageMembersViewState extends State<ManageMembersView> {
  late MembersManager manager;
   @override
  void initState() {
    UserStore userStore = context.read();
    int clubId = userStore.permissions.getClubIdByPermission(PermissionList.manageClubMembers);
    manager = MembersManager(Supabase.instance.client, clubId);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Text('members listpage'),
    );
  }
}