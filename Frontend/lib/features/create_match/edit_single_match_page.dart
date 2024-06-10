import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';
import 'package:darts_application/features/create_match/player_selector.dart';
import 'package:darts_application/features/create_match/confirmation_page.dart';
import 'package:darts_application/models/match.dart';

class EditSingleMatchPage extends StatefulWidget {
  final Map<String, dynamic> match;

  const EditSingleMatchPage({super.key, required this.match});

  @override
  State<EditSingleMatchPage> createState() => _EditSingleMatchPageState();
}

class _EditSingleMatchPageState extends State<EditSingleMatchPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _locationController = TextEditingController();

  late DateTime selectedDate;
  late TimeOfDay selectedTime;

  bool is301Match = true;
  bool is501Match = false;

  String? playerOne;
  String? playerTwo;
  String playerOneName = 'to be decided';
  String playerTwoName = 'to be decided';

  int legAmount = 1;
  int setAmount = 1;

  @override
  void initState() {
    super.initState();
    _initializeFields();
  }

  void _initializeFields() {
    _locationController.text = widget.match['location'] ?? '';
    selectedDate = DateTime.parse(widget.match['date']);
    selectedTime = TimeOfDay.fromDateTime(selectedDate);
    is301Match = widget.match['starting_score'] == 301;
    is501Match = widget.match['starting_score'] == 501;
    playerOne = widget.match['player_1_id'];
    playerTwo = widget.match['player_2_id'];
    playerOneName = widget.match['player_1_last_name'] ?? 'to be decided';
    playerTwoName = widget.match['player_2_last_name'] ?? 'to be decided';
    legAmount = widget.match['leg_target'] ?? 0;
    setAmount = widget.match['set_target'] ?? 0;
  }

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

      final match = Match(
        id: widget.match['id'],
        player1Id: playerOne,
        player2Id: playerTwo,
        date: matchDateTime,
        location: location,
        setTarget: setAmount,
        legTarget: legAmount,
        startingScore: is301Match ? 301 : 501,
        player1LastName: playerOneName,
        player2LastName: playerTwoName,
      );

      try {
        await Supabase.instance.client
            .from('match')
            .update(match.toJson())
            .eq('id', match.id as Object);
        if (mounted) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => ConfirmationPage(match: match),
            ),
          );

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Match updated!')),
          );
        }
      } catch (e) {
        if(mounted){

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
        }
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
      appBar: AppBar(title: const Text('Edit Match')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
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
        DatePicker(
            onDateSelected: updateSelectedDate, initialDate: selectedDate),
        const Padding(
          padding: EdgeInsets.all(8.0),
          child: Text(
            'Time',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        TimePicker(
            onTimeSelected: updateSelectedTime, initialTime: selectedTime),
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
                  initialValue: legAmount.toString(),
                  onChanged: (value) {
                    setState(() {
                      legAmount = int.tryParse(value) ?? 1;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Leg amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty || int.parse(value) < 1) {
                      return 'Please enter a leg amount of at least 1';
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
                  initialValue: setAmount.toString(),
                  onChanged: (value) {
                    setState(() {
                      setAmount = int.tryParse(value) ?? 1;
                    });
                  },
                  decoration: const InputDecoration(
                    labelText: 'Set amount',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  validator: (value) {
                    if (value == null || value.isEmpty || int.parse(value) < 1) {
                      return 'Please enter a set amount of at least 1';
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
        PlayerSelector(onSelectionChanged: updateSelectedPlayer),
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
              'Update match',
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
