// ignore_for_file: avoid_print

import 'dart:async';
import 'package:darts_application/stores/match_store.dart';
import 'package:flutter/material.dart';
// ignore: implementation_imports
import 'package:backend/src/dart_game_service.dart'; // Update the import path as needed
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchStatus extends StatefulWidget {
  final String matchId;

  const MatchStatus({super.key, required this.matchId});

  @override
  // ignore: library_private_types_in_public_api
  _MatchStatusState createState() => _MatchStatusState();
}

class _MatchStatusState extends State<MatchStatus> {
  late final DartGameService _dartGameService;
  late StreamSubscription<List<Map<String, dynamic>>> _matchSubscription;
  late StreamSubscription<List<Map<String, dynamic>>> _turnSubscription;
  Map<String, dynamic>? _matchData;
  int playerOneScore = 0;
  int playerTwoScore = 0;
  String legStand = "0-0";
  String setStand = "0-0";

  @override
  void initState() {
    super.initState();
    _dartGameService = DartGameService(Supabase.instance.client);
    _loadMatchDetails();
    _subscribeToMatchChanges();
    _subscribeToTurnChanges();
  }

  @override
  void dispose() {
    _matchSubscription.cancel();
    _turnSubscription.cancel();
    super.dispose();
  }

  void _loadMatchDetails() async {
    try {
      final response = await _dartGameService.getMatchDetails(widget.matchId);
      if (response != null) {
        setState(() {
          _matchData = response;
          playerOneScore = _matchData?['starting_score'] ?? 0;
          playerTwoScore = _matchData?['starting_score'] ?? 0;
        });
      } else {
        print("No data returned from getMatchDetails.");
      }
    } catch (e) {
      print('Error loading match details: $e');
    }
  }

  void _subscribeToMatchChanges() {
    _matchSubscription =
        _dartGameService.subscribeToMatchChanges(widget.matchId).listen((data) {
      if (data.isNotEmpty) {
        _mergeMatchData(data.first);
      }
    }, onError: (error) {
      print('Error subscribing to match changes: $error');
    });
  }

  void _subscribeToTurnChanges() {
    _turnSubscription =
        _dartGameService.subscribeToTurnChanges(widget.matchId).listen((turn) {
      if (turn.isNotEmpty) {
        _updateScores(turn);
      }
    }, onError: (error) {
      print('Error subscribing to turn changes: $error');
    });
  }

  void _updateScores(List<Map<String, dynamic>> turns) {
    setState(() {
      for (var turn in turns) {
        var playerId = turn['player_id'].toString();
        var score = int.parse(turn['score'].toString());
        if (playerId == _matchData?['player_1_id'].toString()) {
          playerOneScore -= score;
        } else if (playerId == _matchData?['player_2_id'].toString()) {
          playerTwoScore -= score;
        }
      }
    });
  }

  void _mergeMatchData(Map<String, dynamic> newData) {
    setState(() {
      _matchData = {...?_matchData, ...newData};
      legStand = newData['leg_stand'] ?? legStand;
      setStand = newData['set_stand'] ?? setStand;
    });
  }

  @override
  Widget build(BuildContext context) {
MatchStore matchStore = context.read<MatchStore>();
    return _matchData != null
        ? buildMatchUI()
        : const Center(child: CircularProgressIndicator());
  }

  Widget buildMatchUI() {
    final isPlayerOneTurn =
        _matchData!['current_turn'] == _matchData!['player_1_id'];
    final isStartingPlayer =
        _matchData!['starting_player_id'] == _matchData!['player_1_id'];
    final playerOneName = _matchData!['player_1_name'] ?? "Unknown";
    final playerTwoName = _matchData!['player_2_name'] ?? "Unknown";
    final setTarget = _matchData!['set_target'];

    return Container(
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Display set stand only if setTarget is more than 1
          if (setTarget > 1)
            Text(
              setStand,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold),
            ),
          Text(
            legStand,
            style: const TextStyle(
                color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                buildPlayerScore(playerOneName, playerOneScore, isPlayerOneTurn,
                    isStartingPlayer),
                Container(
                  width: 1, // Changed width to 1
                  color: Colors.white,
                  margin: const EdgeInsets.only(
                      top: 116,
                      bottom:
                          12), // Adjusted margin to control length of the vertical divider
                ),
                buildPlayerScore(playerTwoName, playerTwoScore,
                    !isPlayerOneTurn, !isStartingPlayer),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildPlayerScore(
      String name, int score, bool isCurrentTurn, bool isStartingPlayer) {
    return Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(width: 10), // Adjust the width of the spacer
              Text(
                name.toUpperCase(),
                style: TextStyle(
                  color: isCurrentTurn ? Colors.yellow : Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isStartingPlayer)
                const Icon(Icons.star,
                    color: Colors.yellow,
                    size: 20), // An indicator for the starting player
            ],
          ),
          const SizedBox(height: 4),
          Text(
            score.toString(),
            style: TextStyle(
              color: isCurrentTurn ? Colors.yellow : Colors.white,
              fontSize: 52,
              fontWeight: FontWeight.bold,
            ),
          ),
          Container(
            height: 1,
            color: Colors.white,
            margin: const EdgeInsets.only(top: 4, bottom: 8),
          ),
        ],
      ),
    );
  }
}
