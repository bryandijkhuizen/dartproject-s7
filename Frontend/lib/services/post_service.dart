import 'package:darts_application/models/club_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PostService {
  final SupabaseClient _supabaseClient;

  const PostService(this._supabaseClient);

  Future<List<ClubPost>> getLastClubPosts({
    int limit = 3,
    int offset = 0,
    List<int> clubIds = const [],
  }) async {
    var supabaseRequest = _supabaseClient.from('club_post').select();

    if (clubIds.isNotEmpty) {
      supabaseRequest = supabaseRequest.inFilter('club_id', clubIds);
    }

    var from = offset;
    // Doing -1 since range is inclusive
    var to = from + (limit - 1);

    final response = await supabaseRequest
        .order('created_at', ascending: false)
        .range(from, to);

    List<ClubPost> posts =
        response.map((post) => ClubPost.fromJson(post)).toList();

    return posts;
  }
}
