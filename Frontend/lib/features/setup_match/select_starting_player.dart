import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';

class SelectStartingPlayerPageWidget extends StatefulWidget {
  final double buttonHeight;
  final double startMatchPosition;
  final Map<String, ButtonStyle> buttonStyles;
  final Map<String, dynamic> matchDetails;

  const SelectStartingPlayerPageWidget({
    super.key,
    required this.buttonHeight,
    required this.startMatchPosition,
    required this.buttonStyles,
    required this.matchDetails,
  });

  @override
  // ignore: library_private_types_in_public_api
  _SelectStartingPlayerPageWidgetState createState() =>
      _SelectStartingPlayerPageWidgetState();
}

class _SelectStartingPlayerPageWidgetState
    extends State<SelectStartingPlayerPageWidget> {
  bool player1Selected = false;
  bool player2Selected = false;
  Random random = Random();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('./assets/images/bg.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(height: widget.buttonHeight * 0.2), // Top padding
            const Text(
              'Select Starting Player', // Display the heading
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(
                height: widget.buttonHeight * 0.15), // Space below the heading
            ElevatedButton(
              onPressed: () {
                setState(() {
                  player1Selected = true;
                  player2Selected = false;
                });
              },
              style: player1Selected
                  ? widget.buttonStyles['joined']
                  : widget.buttonStyles['notJoined'],
              child: Text(widget.matchDetails['player_1_last_name']),
            ),
            SizedBox(
                height: widget.buttonHeight * 0.15), // Space between buttons
            ElevatedButton(
              onPressed: () {
                setState(() {
                  player1Selected = false;
                  player2Selected = true;
                });
              },
              style: player2Selected
                  ? widget.buttonStyles['joined']
                  : widget.buttonStyles['notJoined'],
              child: Text(widget.matchDetails['player_2_last_name']),
            ),
            SizedBox(height: widget.buttonHeight * 0.15), // Space
            ElevatedButton(
              onPressed: () async {
                final playerId = random.nextBool()
                    ? widget.matchDetails['player_1_id']
                    : widget.matchDetails['player_2_id'];

                // get the according player name with the id
                final playerName =
                    playerId == widget.matchDetails['player_1_id']
                        ? widget.matchDetails['player_1_last_name']
                        : widget.matchDetails['player_2_last_name'];

                await Supabase.instance.client
                    .from('match')
                    .update({'starting_player_id': playerId}).match(
                        {'id': widget.matchDetails['id']});

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: $playerName',
                    ),
                  ),
                );
              },
              style: widget.buttonStyles['random'],
              child: const Text('Random'),
            ),
            SizedBox(
                height: widget.buttonHeight * 0.15), // Space between buttons
            SizedBox(
              height: widget.startMatchPosition - (3 * widget.buttonHeight),
            ),

            ElevatedButton(
              onPressed: () async {
                final playerId = player1Selected
                    ? widget.matchDetails['player_1_id']
                    : widget.matchDetails['player_2_id'];

                await Supabase.instance.client
                    .from('match')
                    .update({'starting_player_id': playerId}).match(
                        {'id': widget.matchDetails['id']});

                // ignore: use_build_context_synchronously
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: ${player1Selected ? widget.matchDetails['player_1_last_name'] : widget.matchDetails['player_2_last_name']}',
                    ),
                  ),
                );
              },
              style: widget.buttonStyles['notJoined'],
              child: const Text('Confirm'),
            ),
          ],
        ),
      ),
    );
  }
}
