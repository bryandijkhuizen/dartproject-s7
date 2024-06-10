import 'package:darts_application/models/tournament.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:darts_application/components/input_fields/time_picker.dart';
import 'package:darts_application/components/input_fields/date_picker.dart';
import 'package:darts_application/features/create_tournament/player_selector.dart';
import 'package:darts_application/models/player.dart';

class CreateTournamentPage extends StatefulWidget {
  const CreateTournamentPage({super.key});

  @override
  State<CreateTournamentPage> createState() => _CreateTournamentPageState();
}

class _CreateTournamentPageState extends State<CreateTournamentPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late DateTime selectedDate = DateTime.now();
  late TimeOfDay selectedTime = TimeOfDay.now();

  bool isBulloffTournament = true;
  bool isRandomTournament = false;

  bool is301Match = true;
  bool is501Match = false;

  int legAmount = 1;
  int setAmount = 1;

  List<PlayerModel> selectedPlayers = [];

  @override
  void dispose() {
    _nameController.dispose();
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

  void updateSelectedPlayers(List<PlayerModel> players) {
    setState(() {
      selectedPlayers = players;
    });
  }

  DateTime parseDateTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  Future<void> submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final String tournamentName = _nameController.text;
      final String tournamentLocation = _locationController.text;
      final DateTime tournamentDateTime =
          parseDateTime(selectedDate, selectedTime);
      final StartingMethod tournamentStartingMethod =
          isBulloffTournament ? StartingMethod.bulloff : StartingMethod.random;

      TournamentModel tournament = TournamentModel(
          id: null,
          name: tournamentName,
          location: tournamentLocation,
          startTime: tournamentDateTime,
          startingMethod: tournamentStartingMethod);

      try {
        final result =
            await Supabase.instance.client.rpc('create_tournament', params: {
          'p_name': tournament.name,
          'p_location': tournament.location,
          'p_start_time': tournament.startTime.toIso8601String(),
          'p_starting_method': tournament.startingMethod.name,
        });

        final int newTournamentID = result;

        tournament = TournamentModel(
            id: newTournamentID,
            name: tournamentName,
            location: tournamentLocation,
            startTime: tournamentDateTime,
            startingMethod: tournamentStartingMethod);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tournament $tournamentName created!')),
        );

        context.push('/matches/create_tournament', extra: {
          'tournament': tournament,
          'players': selectedPlayers,
          'setTarget': setAmount,
          'legTarget': legAmount,
          'startingScore': is301Match ? 301 : 501
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Something went wrong: $e')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Provide a valid input for the required fields!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Tournament')),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: LayoutBuilder(
              builder: (context, constraints) {
                if (constraints.maxWidth > 600) {
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
            'Name',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: _nameController,
            decoration: const InputDecoration(
              labelText: 'Enter the name of the tournament',
              border: OutlineInputBorder(),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please enter a name';
              }
              return null;
            },
          ),
        ),
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
              labelText: 'Enter the location of the tournament',
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
                    if (value == null ||
                        value.isEmpty ||
                        int.parse(value) < 1) {
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
                    if (value == null ||
                        value.isEmpty ||
                        int.parse(value) < 1) {
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
                value: isBulloffTournament,
                onChanged: (value) {
                  setState(() {
                    isBulloffTournament = value!;
                    if (isBulloffTournament) {
                      isRandomTournament = false;
                    }
                  });
                },
              ),
              const Text(
                'Bull-off',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(width: 20),
              Checkbox(
                value: isRandomTournament,
                onChanged: (value) {
                  setState(() {
                    isRandomTournament = value!;
                    if (isRandomTournament) {
                      isBulloffTournament = false;
                    }
                  });
                },
              ),
              const Text(
                'Random',
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
        Padding(
            padding: const EdgeInsets.all(8.0),
            child: PlayerSelector(onSelectionChanged: updateSelectedPlayers)),
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
              'Create tournament',
              style: TextStyle(fontSize: 20),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }
}
