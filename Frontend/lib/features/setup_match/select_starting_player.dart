import 'package:darts_application/features/setup_match/stores/match_setup_store.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match.dart';
import 'dart:math';

import 'package:flutter_mobx/flutter_mobx.dart';

class SelectStartingPlayerPageWidget extends StatefulWidget {
  final double buttonHeight;
  final double startMatchPosition;
  final Map<String, ButtonStyle> buttonStyles;
  final MatchModel matchDetails;
  final MatchSetupStore matchSetupStore;

  const SelectStartingPlayerPageWidget({
    super.key,
    required this.buttonHeight,
    required this.startMatchPosition,
    required this.buttonStyles,
    required this.matchDetails,
    required this.matchSetupStore,
  });

  @override
  _SelectStartingPlayerPageWidgetState createState() =>
      _SelectStartingPlayerPageWidgetState();
}

class _SelectStartingPlayerPageWidgetState
    extends State<SelectStartingPlayerPageWidget> {
  bool player1Selected = false;
  bool player2Selected = false;
  Random random = Random();

  @override
  void initState() {
    super.initState();
    widget.matchSetupStore.fetchMatches();
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

                widget.matchSetupStore
                    .updateStartingPlayer(playerId, widget.matchDetails.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: $playerName',
                    ),
                  ),
                );
                widget.matchSetupStore
                    .redirectToGameplay(widget.matchDetails.id);
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

                widget.matchSetupStore
                    .updateStartingPlayer(playerId, widget.matchDetails.id);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Starting player selected: ${player1Selected ? widget.matchDetails.player1LastName : widget.matchDetails.player2LastName}',
                    ),
                  ),
                );

                widget.matchSetupStore
                    .redirectToGameplay(widget.matchDetails.id);
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
