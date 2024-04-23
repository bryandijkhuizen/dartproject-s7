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
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Match Name (optional)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _matchNameController,
                        decoration: const InputDecoration(
                          labelText: 'Enter the name of the match',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Date',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const DatePicker(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Time',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    const TimePicker(),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Location',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Enter the location of the match',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Expanded(
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Duration (best of)',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Leg amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'Legs',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const SizedBox(width: 250),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              decoration: const InputDecoration(
                                labelText: 'Set amount',
                                border: OutlineInputBorder(),
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly
                              ],
                            ),
                          ),
                          const SizedBox(width: 20),
                          const Text(
                            'Sets',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const SizedBox(width: 250),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Match type',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const Text(
                            '301',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 20),
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const Text(
                            '501',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Starting method',
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Bull-off',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                          const SizedBox(width: 20),
                          Checkbox(
                            value: false,
                            onChanged: (bool? value) {
                              // Handle checkbox state change
                            },
                            checkColor: Colors.white,
                            activeColor: Colors.green,
                          ),
                          const Text(
                            'Random',
                            style: TextStyle(color: Colors.white, fontSize: 16),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              )
            )
          ],
        )
      ),
    );
  }
}
