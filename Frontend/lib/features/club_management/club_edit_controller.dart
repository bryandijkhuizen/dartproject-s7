import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';

class ClubEditController {
  final SupabaseClient supabaseClient;
  int clubId;
  Future<Map<String, String?>> model;
  ClubEditController(this.supabaseClient, this.clubId)
      : model = _fetchClubInfo(clubId);

  static Future<Map<String, String?>> _fetchClubInfo(int clubId) async {
  final response = await Supabase.instance.client.rpc(
      "get_club_details",
      params: {'current_club_id': clubId}
  );

  // Assuming the response is a list of maps and you need the first element
  final Map<String, dynamic> data = response[0];

  // Define the prefix to remove
  const String prefixToRemove = "current_";

  // Convert Map<String, dynamic> to Map<String, String> and remove the prefix from keys
  final Map<String, String?> clubInfo = data.map((key, value) {
    final newKey = key.startsWith(prefixToRemove)
        ? key.substring(prefixToRemove.length)
        : key;
    return MapEntry(newKey, value.toString());
  });

  return clubInfo;
}

}
