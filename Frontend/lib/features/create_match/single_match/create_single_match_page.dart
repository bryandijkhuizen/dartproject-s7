import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';

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
        padding: EdgeInsets.all(20.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
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
                      labelText: 'Enter the name of the match',
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Date',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const DatePicker(),
                  const SizedBox(height: 20),
                  const Text(
                    'Time',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  const TimePicker(),
                  const SizedBox(height: 20),
                  const Text(
                    'Location',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _locationController,
                    decoration: const InputDecoration(
                      labelText: 'Enter the location of the match',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 20),
            const Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Duration (best of)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        'FIRST',
                        style: TextStyle(fontSize: 20.0),
                      ),
                      Text(
                        'SECOND',
                        style: TextStyle(fontSize: 20.0),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),
                  Text(
                    'Match type',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  
                  SizedBox(height: 10),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
