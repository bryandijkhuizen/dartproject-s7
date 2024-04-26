import 'package:flutter/material.dart';
import 'dart:async';
import 'package:backend/src/dart_game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchStatus extends StatefulWidget {
  final String matchId;

  const MatchStatus({Key? key, required this.matchId}) : super(key: key);

  @override
  _MatchStatusState createState() => _MatchStatusState();
}

class _MatchStatusState extends State<MatchStatus> {
  late final DartGameService _dartGameService;
  Map<String, dynamic>? _matchData;
  late StreamSubscription _matchChangesSubscription;
  late StreamSubscription _turnsSubscription;

  @override
  void initState() {
    super.initState();
    _dartGameService = DartGameService(Supabase.instance.client);

    _fetchMatchDetails();

    _matchChangesSubscription =
        _dartGameService.subscribeToMatchChanges(widget.matchId).listen((data) {
      if (data is Map<String, dynamic>) {
        setState(() => _matchData = data as Map<String, dynamic>?);
      }
    }, onError: (error) => print('Error listening to match changes: $error'));

    _turnsSubscription = _dartGameService
        .subscribeToTurns(widget.matchId)
        .listen((data) {},
            onError: (error) =>
                print('Error listening to turns changes: $error'));
  }

  Future<void> _fetchMatchDetails() async {
    try {
      final response = await _dartGameService.getMatchDetails(widget.matchId);

      setState(() => _matchData = response['data']);
    } catch (e) {
      print('Error fetching match details: $e');
    }
  }

  @override
  void dispose() {
    _matchChangesSubscription.cancel();
    _turnsSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> matchData = _matchData ??
        {
          'player_1_name': 'Speler 1',
          'player_1_score': 501,
          'player_2_name': 'Speler 2',
          'player_2_score': 501,
          'current_turn': 'player_1_id',
          'leg_stand': '0 - 0',
        };

    bool isPlayerOneTurn = matchData['current_turn'] == 'player_1_id';

    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            matchData['leg_stand'],
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Expanded(
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildPlayerScore(matchData['player_1_name'],
                      matchData['player_1_score'], isPlayerOneTurn),
                  Container(
                    width: 3,
                    color: Colors.white,
                    margin: EdgeInsets.only(top: 8, bottom: 8),
                  ),
                  _buildPlayerScore(matchData['player_2_name'],
                      matchData['player_2_score'], !isPlayerOneTurn),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerScore(String name, int score, bool isCurrentTurn) {
    return Expanded(
      child: Column(
        children: [
          Text(
            name.toUpperCase(),
            style: TextStyle(
              color: isCurrentTurn ? Colors.yellow : Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              color: isCurrentTurn ? Colors.yellow : Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 3,
            color: isCurrentTurn ? Colors.yellow : Colors.white,
            margin: EdgeInsets.only(top: 4),
          ),
        ],
      ),
    );
  }
}
