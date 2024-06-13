import 'package:darts_application/models/club_post.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClubPostsResponse {
  final List<ClubPost> posts;
  final int queryResults;

  const ClubPostsResponse({required this.posts, required this.queryResults});

  factory ClubPostsResponse.fromPostgrestResponse(
      PostgrestResponse<List<Map<String, dynamic>>> response) {
    List<ClubPost> posts =
        response.data.map((post) => ClubPost.fromJson(post)).toList();

    int queryResults = response.count;

    return ClubPostsResponse(posts: posts, queryResults: queryResults);
  }
}
