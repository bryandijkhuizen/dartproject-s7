import 'dart:async';

import 'package:darts_application/models/club.dart';
import 'package:darts_application/models/club_approval.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubManagementController {

  final SupabaseClient supabaseClient;
  Future<List<Club>> clubs;
  Future<List<ClubApproval>> newClubs;  
  ClubManagementController(this.supabaseClient) : clubs = _fetchClubs(), newClubs = _fetchNewClubs();

  static Future<List<Club>> _fetchClubs() async {
    List<Club> clubModels = [];
    
    final response = await Supabase.instance.client.rpc(
        "get_approved_clubs");

    for (var element in response) {
      clubModels.add(Club.fromJson(element));
    }
    return clubModels;
  }

  static Future<List<ClubApproval>> _fetchNewClubs() async {
    List<ClubApproval> clubModels = [];
    
    final response = await Supabase.instance.client.rpc(
        "get_not_approved_clubs");

    for (var element in response) {
      clubModels.add(ClubApproval.fromJson(element));
    }
    return clubModels;
  }
}
