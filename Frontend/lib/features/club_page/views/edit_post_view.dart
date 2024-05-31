import 'package:flutter/material.dart';

class EditPostView extends StatelessWidget {
  final String postId;

  const EditPostView({super.key, required this.postId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
              // Initialize with existing post title
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Content',
              ),
              maxLines: 10,
              // Initialize with existing post content
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle post editing logic here
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
