import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class MembersController {

  final SupabaseClient supabaseClient;
  int clubId;
  Future<Map<String, String>> members;
  Future<Map<String, String>> newmembers;  
  MembersController(this.supabaseClient,this.clubId) : members = _fetchMembers(clubId), newmembers = _fetchNewMembers(clubId);

  static Future<Map<String,String>> _fetchMembers(int clubId) async {
    Map<String, String> membersmap = {};
    
    final response = await Supabase.instance.client.rpc(
        "get_club_member_names_and_ids",
        params: {'current_club_id': clubId});
    for (var userdata in response ?? []) {
      membersmap.addAll(<String,String>{userdata['user_id']: userdata['first_name'] });
    }
    return membersmap;
  }

  static Future<Map<String,String>> _fetchNewMembers(int clubId) async {
    Map<String, String> newmembers = {};
    
    final response = await Supabase.instance.client.rpc(
        "get_not_approved_club_member_names_and_ids",
        params: {'current_club_id': clubId});
    for (var userdata in response ?? []) {
      newmembers.addAll(<String,String>{userdata['user_id']: userdata['first_name'] });
    }
    return newmembers;
  }
}
