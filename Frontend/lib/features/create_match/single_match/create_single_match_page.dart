import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';

import 'package:darts_application/features/create_match/single_match/player_selector.dart';
import 'package:darts_application/features/create_match/single_match/confirmation_page.dart';

class CreateSingleMatchPage extends StatefulWidget {
  const CreateSingleMatchPage({super.key});

  @override
  State<CreateSingleMatchPage> createState() => _CreateSingleMatchPageState();
}

class _CreateSingleMatchPageState extends State<CreateSingleMatchPage> {
  final TextEditingController _locationController = TextEditingController();

  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();

  bool useLegDuration = false;
  bool useSetDuration = false;

  bool is301Match = true;
  bool is501Match = false;

  String playerOne = "";
  String playerTwo = "";

  int legAmount = 0;
  int setAmount = 0;

  @override
  void dispose() {
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

  Future<void> submitForm() async {
    String location = _locationController.text;

    DateTime matchDateTime = DateTime(selectedDate.year, selectedDate.month,
        selectedDate.day, selectedTime.hour, selectedTime.minute);

    if (location.isNotEmpty && playerOne.isNotEmpty && playerTwo.isNotEmpty) {
      try {
        await Supabase.instance.client.from('match').upsert({
          'set_target': setAmount,
          'leg_target': legAmount,
          'starting_score': is301Match ? 301 : 501,
          'player_1_id': playerOne,
          'player_2_id': playerTwo,
          'date': matchDateTime.toString(),
          'location': location,
        });

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmationPage(
              location: location,
              matchDateTime: matchDateTime,
              playerOne: playerOne,
              playerTwo: playerTwo,
              legAmount: legAmount,
              setAmount: setAmount,
              is301Match: is301Match,
            ),
          ),
        );

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Match created!',
            ),
          ),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Something went wrong: $e',
            ),
          ),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'You did not fill in all the required fields!',
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Location',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
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
                      ),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Date',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      DatePicker(onDateSelected: updateSelectedDate),
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Time',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                      TimePicker(onTimeSelected: updateSelectedTime),
                    ],
                  ),
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text(
                        'Duration (best of)',
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
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
                  ],
                )),
              ]),
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Select players',
                      style:
                          TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: submitForm,
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
