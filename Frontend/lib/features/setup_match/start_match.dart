import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/features/setup_match/select_starting_player.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';

class StartMatch extends StatefulWidget {
  final String matchId;
  const StartMatch({super.key, required this.matchId});

  @override
  State<StartMatch> createState() => _StartMatchState();
}

class _StartMatchState extends State<StartMatch> {
  late PageController _pageController;
  bool player1Joined = false;
  bool player2Joined = false;
  bool markerJoined = false;
  MatchModel matchDetails = MatchModel(
    id: '',
    player1Id: '',
    player2Id: '',
    date: DateTime.now(),
    setTarget: 0,
    legTarget: 0,
    startingScore: 501,
    player1LastName: '',
    player2LastName: '',
  );

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);
    fetchMatchDetails();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  Future<void> fetchMatchDetails() async {
    try {
      final matchResponse = await Supabase.instance.client
          .rpc('get_match_by_id', params: {'match_id': widget.matchId});

      MatchModel match = MatchModel.fromJson(matchResponse[0]);

      final userResponse = await Supabase.instance.client.from('user').select();

      List<PlayerModel> players = userResponse
          .map<PlayerModel>((user) => PlayerModel.fromJson(user))
          .toList();

      match.player1LastName =
          players.firstWhere((player) => player.id == match.player1Id).lastName;

      match.player2LastName =
          players.firstWhere((player) => player.id == match.player2Id).lastName;

      setState(() {
        matchDetails = match;
      });
    } catch (e) {
      throw Exception('Failed to fetch match details: $e');
    }
  }

  bool allPlayersJoined() {
    return player1Joined && player2Joined && markerJoined;
  }

  var buttonStyles = {
    'joined': ElevatedButton.styleFrom(
      backgroundColor: Colors.grey,
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
    ),
    'random': ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF2C4789),
      foregroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
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
            matchDetails: matchDetails,
          ),
        ],
      ),
    );
  }

  Widget buildJoinMatchPage(
      BuildContext context, double buttonHeight, double startMatchPosition) {
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
            SizedBox(height: buttonHeight * 0.2),
            Text(
              'Match ID: ${widget.matchId}',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: buttonHeight * 0.15),
            ElevatedButton(
              style: buttonStyles[player1Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player1Joined = true;
                });
              },
              child: Text(player1Joined
                  ? 'Joined as ${matchDetails.player1LastName}'
                  : 'Join as ${matchDetails.player1LastName}'),
            ),
            SizedBox(height: buttonHeight * 0.15),
            ElevatedButton(
              style: buttonStyles[player2Joined ? 'joined' : 'notJoined'],
              onPressed: () {
                setState(() {
                  player2Joined = true;
                });
              },
              child: Text(player2Joined
                  ? 'Joined as ${matchDetails.player2LastName}'
                  : 'Join as ${matchDetails.player2LastName}'),
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
                  _pageController.nextPage(
                    duration: const Duration(milliseconds: 500),
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
