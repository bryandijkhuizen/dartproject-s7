import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/post_card.dart';
import 'package:darts_application/models/club_post.dart';

class ClubPostsView extends StatefulWidget {
  final String clubId;
  const ClubPostsView({super.key, required this.clubId});

  @override
  ClubPostsViewState createState() => ClubPostsViewState();
}

class ClubPostsViewState extends State<ClubPostsView> {
  late Future<List<ClubPost>> futureClubPosts;

  @override
  void initState() {
    super.initState();
    futureClubPosts = fetchPosts();
  }

  Future<List<ClubPost>> fetchPosts() async {
    try {
      final postResponse =
          await Supabase.instance.client.from('club_post').select().eq('club_id', widget.clubId);;
      final List<dynamic> postData = postResponse as List<dynamic>;
      List<ClubPost> fetchedPosts = postData.map((row) {
        return ClubPost.fromJson(row);
      }).toList();
      
      return fetchedPosts;
    } catch (e) {
      print('Error fetching data: $e');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ClubPost>>(
      future: futureClubPosts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No posts available'));
        } else {
          final clubPosts = snapshot.data!;
          return ListView.builder(
            itemCount: clubPosts.length,
            itemBuilder: (context, index) {
              final post = clubPosts[index];
              return PostCard(
                post: post,
              );
            },
          );
        }
      },
    );
  }
}
