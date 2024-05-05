import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';

import 'package:darts_application/features/create_match/single_match/player_selector.dart';

class CreateSingleMatchPage extends StatefulWidget {
  const CreateSingleMatchPage({super.key});

  @override
  State<CreateSingleMatchPage> createState() => _CreateSingleMatchPageState();
}

class _CreateSingleMatchPageState extends State<CreateSingleMatchPage> {
  final TextEditingController _matchNameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  bool useLegDuration = false;
  bool useSetDuration = false;

  bool is301Match = true;
  bool is501Match = false;

  bool bullOffStart = true;
  bool randomStart = false;

  String? playerOne;
  String? playerTwo;

  int legAmount = 0;
  int setAmount = 0;

  @override
  void dispose() {
    _matchNameController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  void updateSelectedDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  void updateSelectedTime(TimeOfDay time) {
    setState(() {
      selectedTime = time;
    });
  }

  void updateSelectedPlayer(String selectedOne, String selectedTwo) {
    setState(() {
      playerOne = selectedOne;
      playerTwo = selectedTwo;
    });
  }

  void _submitForm() {
    String matchName = _matchNameController.text;
    String location = _locationController.text;

    // Add database logic here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Single Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
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
                          DatePicker(onDateSelected: updateSelectedDate),
                          const Padding(
                            padding: EdgeInsets.all(8.0),
                            child: Text(
                              'Time',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                          ),
                          TimePicker(onTimeSelected: updateSelectedTime),
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
                                    onChanged: (value) {
                                      setState(() {
                                        legAmount = int.tryParse(value) ?? 0;
                                      });
                                    },
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
                                  value: useLegDuration,
                                  onChanged: (value) {
                                    setState(() {
                                      useLegDuration = value!;
                                    });
                                  },
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
                                    onChanged: (value) {
                                      setState(() {
                                        setAmount = int.tryParse(value) ?? 0;
                                      });
                                    },
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
                                  value: useSetDuration,
                                  onChanged: (value) {
                                    setState(() {
                                      useSetDuration = value!;
                                    });
                                  },
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
                                  value: is301Match,
                                  onChanged: (value) {
                                    setState(() {
                                      is301Match = value!;
                                      if (is301Match) {
                                        is501Match = false;
                                      }
                                    });
                                  },
                                ),
                                const Text(
                                  '301',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(width: 20),
                                Checkbox(
                                  value: is501Match,
                                  onChanged: (value) {
                                    setState(() {
                                      is501Match = value!;
                                      if (is501Match) {
                                        is301Match = false;
                                      }
                                    });
                                  },
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
                                  value: bullOffStart,
                                  onChanged: (value) {
                                    setState(() {
                                      bullOffStart = value!;
                                      if (bullOffStart) {
                                        randomStart = false;
                                      }
                                    });
                                  },
                                ),
                                const Text(
                                  'Bull-off',
                                  style: TextStyle(color: Colors.white, fontSize: 16),
                                ),
                                const SizedBox(width: 20),
                                Checkbox(
                                  value: randomStart,
                                  onChanged: (value) {
                                    setState(() {
                                      randomStart = value!;
                                      if (randomStart) {
                                        bullOffStart = false;
                                      }
                                    });
                                  },
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
                  ),
                ]
              ),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select players',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  PlayerSelector(onSelectionChanged: updateSelectedPlayer),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0612),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () {  },
                child: const Text(
                  'Create match',
                  style: TextStyle(fontSize: 20),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
