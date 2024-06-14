import 'package:darts_application/exceptions/supabase_exception.dart';
import 'package:darts_application/features/clubs/stores/club_registration_view_store.dart';
import 'package:darts_application/models/match.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchService {
  final SupabaseClient _supabaseClient;

  const MatchService(this._supabaseClient);

  Future<MatchModel> getNextMatch(String? userId) async {
    try {
      // Some DB Call
      var response = await _supabaseClient
          .rpc('get_next_match_by_user_id', params: {'user_id': userId});

      var result = SupabaseResultType.fromJson(response);

      // No succexss
      if (!result.success) {
        throw SupabaseException(result.message);
      }

      // Successful but no data
      if (result.data == null) {
        throw SupabaseException('Invalid data received');
      }

      return MatchModel.fromJson(result.data);
    } catch (error) {
      rethrow;
    }
  }
}
