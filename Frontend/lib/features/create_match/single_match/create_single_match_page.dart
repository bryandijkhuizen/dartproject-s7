import 'package:flutter/material.dart';

class CreateSingleMatchPage extends StatefulWidget {
  const CreateSingleMatchPage({super.key});

  @override
  State<CreateSingleMatchPage> createState() => _CreateSingleMatchPageState();
}

class _CreateSingleMatchPageState extends State<CreateSingleMatchPage> {
  final TextEditingController _matchNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  @override
  void dispose() {
    _matchNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Single Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Match Name (optional)',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _matchNameController,
              decoration: const InputDecoration(
                hintText: 'Enter the name of the match',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Location',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _locationController,
              decoration: const InputDecoration(
                hintText: 'Enter the location of the match',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
