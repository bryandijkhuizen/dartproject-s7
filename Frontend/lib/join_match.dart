import 'package:flutter/material.dart';

class JoinMatch extends StatefulWidget {
  const JoinMatch({Key? key}) : super(key: key);

  @override
  State<JoinMatch> createState() => _JoinMatchState();
}

class _JoinMatchState extends State<JoinMatch> {
  bool player1Joined = false;
  bool player2Joined = false;
  bool markerJoined = false;

  bool allPlayersJoined() {
    return player1Joined && player2Joined && markerJoined;
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
      body: Container(
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
                    // Handle start match
                  },
                  child: const Text('Start Match'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
