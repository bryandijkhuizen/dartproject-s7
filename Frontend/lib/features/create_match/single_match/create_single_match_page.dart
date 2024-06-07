import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';
import 'package:darts_application/features/create_match/single_match/player_selector.dart';
import 'package:darts_application/features/create_match/single_match/confirmation_page.dart';
import 'package:darts_application/models/match.dart';

class CreateSingleMatchPage extends StatefulWidget {
  const CreateSingleMatchPage({super.key});

  @override
  State<CreateSingleMatchPage> createState() => _CreateSingleMatchPageState();
}

class _CreateSingleMatchPageState extends State<CreateSingleMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();

  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();

  bool is301Match = true;
  bool is501Match = false;

  bool isFriendly = false;

  String playerOne = "";
  String playerTwo = "";
  String playerOneName = "";
  String playerTwoName = "";

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

  void updateSelectedPlayer(String selectedOne, String selectedTwo,
      String selectedOneName, String selectedTwoName) {
    setState(() {
      playerOne = selectedOne;
      playerTwo = selectedTwo;
      playerOneName = selectedOneName;
      playerTwoName = selectedTwoName;
    });
  }

  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      String location = _locationController.text;
      DateTime matchDateTime = DateTime(selectedDate.year, selectedDate.month,
          selectedDate.day, selectedTime.hour, selectedTime.minute);

      final match = MatchModel(
        id: UniqueKey().toString(),
        player1Id: playerOne,
        player2Id: playerTwo,
        date: matchDateTime,
        location: location,
        setTarget: setAmount,
        legTarget: legAmount,
        startingScore: is301Match ? 301 : 501,
        player1LastName: playerOneName,
        player2LastName: playerTwoName,
        isFriendly: isFriendly,
      );

      try {
        await Supabase.instance.client.from('match').upsert(match.toJson());
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ConfirmationPage(match: match),
          ),
        );
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Match created!')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('You did not fill in all the required fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Match')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
                  // For larger screens, display two columns side by side
                  return Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(child: buildLeftColumn()),
                          const SizedBox(width: 20),
                          Expanded(child: buildRightColumn()),
                        ],
                      ),
                      const SizedBox(height: 20),
                      buildFullWidthColumn(),
                    ],
                  );
                } else {
                  // For smaller screens, display columns vertically
                  return Column(
                    children: [
                      buildLeftColumn(),
                      const SizedBox(height: 20),
                      buildRightColumn(),
                      const SizedBox(height: 20),
                      buildFullWidthColumn(),
                    ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget buildLeftColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Location',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _locationController,
            decoration: const InputDecoration(
              labelText: 'Enter the location of the match',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a location';
              }
              return null;
            },
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
      ],
    );
  }

  Widget buildRightColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
                child: TextFormField(
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter leg amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                'Legs',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
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
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter set amount';
                    }
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 20),
              const Text(
                'Sets',
                style: TextStyle(fontSize: 16),
              ),
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
                style: TextStyle(fontSize: 16),
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
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              Checkbox(
                value: isFriendly,
                onChanged: (value) {
                  setState(() {
                    isFriendly = value!;
                  });
                },
              ),
              const Text(
                'Friendly match',
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildFullWidthColumn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Select players',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        PlayerSelector(
          onSelectionChanged: updateSelectedPlayer,
          isFriendly: isFriendly,
        ),
        const SizedBox(height: 20),
        Center(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCD0612),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: submitForm,
            child: const Text(
              'Create match',
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
