import 'package:flutter/material.dart';

class JoinMatch extends StatefulWidget {
  const JoinMatch({Key? key}) : super(key: key);

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
    ),
    'joined': ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
    ),
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Join Match'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              style: buttonStyles[player1Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player1Joined = true;
                });
              },
              child: const Text('Join as Player 1'),
            ),
            ElevatedButton(
              style: buttonStyles[player2Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player2Joined = true;
                });
              },
              child: const Text('Join as Player 2'),
            ),
            ElevatedButton(
              style: buttonStyles[markerJoined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  markerJoined = true;
                });
              },
              child: const Text('Join as Marker'),
            ),
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
    );
  }
}
