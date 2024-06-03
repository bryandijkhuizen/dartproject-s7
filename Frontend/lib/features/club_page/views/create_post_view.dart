import 'package:flutter/material.dart';

class CreatePostView extends StatelessWidget {
  const CreatePostView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create Post'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              decoration: InputDecoration(
                labelText: 'Content',
              ),
              maxLines: 10,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Handle post creation logic here
              },
              child: Text('Create Post'),
            ),
          ],
        ),
      ),
    );
  }
}
