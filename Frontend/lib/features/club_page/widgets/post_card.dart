import 'package:flutter/material.dart';

class PostCard extends StatelessWidget {
  final String postContent;

  const PostCard({super.key, required this.postContent});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(postContent),
      ),
    );
  }
}
