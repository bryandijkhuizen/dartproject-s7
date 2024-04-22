import 'package:flutter/material.dart';

class SelectStartingPlayerPageWidget extends StatefulWidget {
  final double buttonHeight;
  final double startMatchPosition;
  final Map<String, ButtonStyle> buttonStyles;

  const SelectStartingPlayerPageWidget({
    required this.buttonHeight,
    required this.startMatchPosition,
    required this.buttonStyles,
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
              child: const Text('Player 1'),
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
              child: const Text('Player 2'),
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
              onPressed: () {
                // Add logic to confirm selection and proceed
              },
              child: const Text('Confirm'),
              style: widget.buttonStyles['notJoined'],
            ),
          ],
        ),
      ),
    );
  }
}
