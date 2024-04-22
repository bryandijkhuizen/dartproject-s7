import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SelectStartingPlayerPageWidget extends StatefulWidget {
  final double buttonHeight;
  final double startMatchPosition;
  final Map<String, ButtonStyle> buttonStyles;
  final Map<String, dynamic> matchDetails;

  const SelectStartingPlayerPageWidget({
    required this.buttonHeight,
    required this.startMatchPosition,
    required this.buttonStyles,
    required this.matchDetails,
  });

  @override
  _SelectStartingPlayerPageWidgetState createState() =>
      _SelectStartingPlayerPageWidgetState();
}

class _SelectStartingPlayerPageWidgetState
    extends State<SelectStartingPlayerPageWidget> {
  bool player1Selected = false;
  bool player2Selected = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
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
            Text(
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
              child: Text(widget.matchDetails['player_1_last_name']),
              style: player1Selected
                  ? widget.buttonStyles['joined']
                  : widget.buttonStyles['notJoined'],
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
              child: Text(widget.matchDetails['player_2_last_name']),
              style: player2Selected
                  ? widget.buttonStyles['joined']
                  : widget.buttonStyles['notJoined'],
            ),
            SizedBox(
                height: widget.buttonHeight * 0.15), // Space between buttons
            SizedBox(
              height: widget.startMatchPosition - (3 * widget.buttonHeight),
            ), // Space to push buttons to 3/4 of the page
            ElevatedButton(
              onPressed: () async {
                final playerId = player1Selected
                    ? widget.matchDetails['player_1_id']
                    : widget.matchDetails['player_2_id'];

                await Supabase.instance.client
                    .from('match')
                    .update({'starting_player_id': playerId}).match(
                        {'id': widget.matchDetails['id']});

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: ${player1Selected ? widget.matchDetails['player_1_last_name'] : widget.matchDetails['player_2_last_name']}',
                    ),
                  ),
                );
              },
              child: const Text('Confirm'),
              style: widget.buttonStyles['notJoined'],
            )
          ],
        ),
      ),
    );
  }
}
