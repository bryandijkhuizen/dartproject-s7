import 'package:flutter/material.dart';

import 'select_starting_widget.dart';

class StartMatch extends StatefulWidget {
  final String matchId;
  const StartMatch({Key? key, required this.matchId}) : super(key: key);

  @override
  State<StartMatch> createState() => _StartMatchState();
}

class _StartMatchState extends State<StartMatch> {
  late PageController _pageController;
  bool player1Joined = false;
  bool player2Joined = false;
  bool markerJoined = false;

  bool allPlayersJoined() {
    return player1Joined && player2Joined && markerJoined;
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  // buttonstyle
  var buttonStyles = {
    'notJoined': ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFCD0612),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      ),
    ),
    'joined': ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Adjust the radius as needed
      ),
    ),
  };

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = screenHeight * 0.15;
    final startMatchPosition = screenHeight * 0.65;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Match'),
        backgroundColor: const Color(0xFFCD0612),
        foregroundColor: Colors.white,
      ),
      body: PageView(
        controller: _pageController,
        children: [
          buildJoinMatchPage(context, buttonHeight, startMatchPosition),
          SelectStartingPlayerPageWidget(
            buttonHeight: buttonHeight,
            startMatchPosition: startMatchPosition,
            buttonStyles: buttonStyles,
          ),
        ],
      ),
    );
  }

  Widget buildJoinMatchPage(
      BuildContext context, double buttonHeight, double startMatchPosition) {
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
            SizedBox(height: buttonHeight * 0.2), // Top padding
            Text(
              'Match ID: ${widget.matchId}', // Display the match ID on the screen
              style: TextStyle(
                fontSize: 24, // Adjust the font size as needed
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: buttonHeight * 0.15), // Space below the match ID
            ElevatedButton(
              style: buttonStyles[player1Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player1Joined = true;
                });
              },
              child: const Text('Join as Player 1'),
            ),
            SizedBox(height: buttonHeight * 0.15), // Space between buttons
            ElevatedButton(
              style: buttonStyles[player2Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player2Joined = true;
                });
              },
              child: const Text('Join as Player 2'),
            ),
            SizedBox(height: buttonHeight * 0.15), // Space between buttons
            ElevatedButton(
              style: buttonStyles[markerJoined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  markerJoined = true;
                });
              },
              child: const Text('Join as Marker'),
            ),
            SizedBox(
                height: startMatchPosition -
                    (3 *
                        buttonHeight)), // Space to push buttons to 3/4 of the page
            if (allPlayersJoined())
              ElevatedButton(
                style: buttonStyles['notJoined'],
                onPressed: () {
                  // Switch to the next page
                  _pageController.nextPage(
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeInOut,
                  );
                },
                child: const Text('Start Match'),
              ),
          ],
        ),
      ),
    );
  }
}
