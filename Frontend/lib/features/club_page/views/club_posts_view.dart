import 'package:flutter/material.dart';
import '../widgets/post_card.dart';

class ClubPostsView extends StatefulWidget {
  const ClubPostsView({super.key});

  @override
  ClubPostsViewState createState() => ClubPostsViewState();
}

class ClubPostsViewState extends State<ClubPostsView> {
  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        PostCard(postContent: 'Lorem ipsum'),
        SizedBox(height: 20),
        PostCard(postContent: 'Lorem ipsum'),
      ],
    );
  }
}
