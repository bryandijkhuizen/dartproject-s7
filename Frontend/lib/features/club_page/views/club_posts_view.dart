import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../widgets/post_card.dart';
import 'package:darts_application/models/club_post.dart';
import 'post_detail_view.dart';

class ClubPostsView extends StatefulWidget {
  final String clubId;
  final int? limit;

  const ClubPostsView({super.key, required this.clubId, this.limit});

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
      var query = Supabase.instance.client.from('club_post').select().eq('club_id', widget.clubId).order('id', ascending: false);
      if (widget.limit != null) {
        query = query.limit(widget.limit!);
      }
      final postResponse = await query;
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
          return Column(
            children: [
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: clubPosts.length,
                itemBuilder: (context, index) {
                  final post = clubPosts[index];
                  return PostCard(
                    post: post,
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PostDetailView(post: post),
                        ),
                      );
                    },
                  );
                },
              ),
              if (widget.limit != null && clubPosts.length >= widget.limit!)
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ClubPostsFullView(clubId: widget.clubId),
                      ),
                    );
                  },
                  child: const Text('Show more'),
                ),
            ],
          );
        }
      },
    );
  }
}

class ClubPostsFullView extends StatelessWidget {
  final String clubId;

  const ClubPostsFullView({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('All Posts'),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ClubPostsView(clubId: clubId),
          ],
        ),
      ),
    );
  }
}
