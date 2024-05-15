import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'dart:math';

class SelectStartingPlayerPageWidget extends StatefulWidget {
  final double buttonHeight;
  final double startMatchPosition;
  final Map<String, ButtonStyle> buttonStyles;
  final MatchModel matchDetails;

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

  Future<void> updateStartingPlayer(String playerId, String matchId) async {}
}

class _SelectStartingPlayerPageWidgetState
    extends State<SelectStartingPlayerPageWidget> {
  bool player1Selected = false;
  bool player2Selected = false;
  Random random = Random();

  void redirecToGameplay(matchId) {
    context.go('/gameplay/$matchId');
  }

  Future<void> updateStartingPlayer(playerId, matchId) async {
    await Supabase.instance.client.rpc('update_starting_player',
        params: {'current_match_id': matchId, 'player_id': playerId});
  }

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
            SizedBox(height: widget.buttonHeight * 0.15),
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
              child: Text(widget.matchDetails.player1LastName),
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
              child: Text(widget.matchDetails.player2LastName),
            ),
            SizedBox(height: widget.buttonHeight * 0.15), // Space
            ElevatedButton(
              onPressed: () async {
                final playerId = random.nextBool()
                    ? widget.matchDetails.player1Id
                    : widget.matchDetails.player2Id;

                final playerName = playerId == widget.matchDetails.player1Id
                    ? widget.matchDetails.player1LastName
                    : widget.matchDetails.player2LastName;

                updateStartingPlayer(playerId, widget.matchDetails.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: $playerName',
                    ),
                  ),
                );
                redirecToGameplay(widget.matchDetails.id);
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
                    ? widget.matchDetails.player1Id
                    : widget.matchDetails.player2Id;

                updateStartingPlayer(playerId, widget.matchDetails.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: ${player1Selected ? widget.matchDetails.player1LastName : widget.matchDetails.player2LastName}',
                    ),
                  ),
                );

                redirecToGameplay(widget.matchDetails.id);
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
