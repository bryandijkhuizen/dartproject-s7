import 'package:flutter/material.dart';

class CreateSelector extends StatefulWidget {
  const CreateSelector({super.key});

  @override
  State<CreateSelector> createState() => _CreateSelectorState();
}

class _CreateSelectorState extends State<CreateSelector> {
  
  @override
  void dispose() {
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: const Padding(
        padding: EdgeInsets.all(20.0),
        child: Row(
          children: [
            Text(
              'Do you want to create a single match or tournament?',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ]
        )
      )
    );
  }
}