import 'package:flutter/material.dart';
import 'package:darts_application/models/club_post.dart';

class PostDetailView extends StatelessWidget {
  final ClubPost post;

  const PostDetailView({super.key, required this.post});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(post.title),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (post.imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.network(
                  post.imageUrl!,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: double.infinity,
                      height: 200,
                      color: Colors.grey,
                      child: const Icon(Icons.broken_image, size: 50),
                    );
                  },
                ),
              ),
            const SizedBox(height: 16.0),
            Text(
              post.title,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16.0),
            Text(
              post.body,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
