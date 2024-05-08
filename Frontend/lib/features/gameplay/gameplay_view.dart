import 'package:flutter/material.dart';
import 'score_input.dart';
import 'match_status.dart';
import 'end_of_match_view.dart';
// ignore: implementation_imports
import 'package:backend/src/dart_game_service.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class GameplayView extends StatefulWidget {
  final String matchId;

  const GameplayView({super.key, required this.matchId});

  @override
  _GameplayViewState createState() => _GameplayViewState();
}

class _GameplayViewState extends State<GameplayView> {
  late String currentLegId;
  late String currentPlayerId;
  late DartGameService _gameService;

  @override
  void initState() {
    super.initState();
    currentLegId = '';
    currentPlayerId = '';
    _gameService = DartGameService(Supabase.instance.client);
    _fetchGameDetails();
  }

  Future<void> _fetchGameDetails() async {
    try {
      final legStand = await _gameService.getCurrentLegStand(widget.matchId);

      // Controleren op legId
      if (legStand.isNotEmpty) {
        currentLegId = legStand.keys.first;
      } else {
        throw DartGameException('Failed to fetch leg stand');
      }

      final setStand = await _gameService.getCurrentSetStand(widget.matchId);

      // Controleren op playerId
      if (setStand.isNotEmpty) {
        final currentSetId = setStand.keys.first;
        currentPlayerId = setStand[currentSetId]! > legStand[currentLegId]!
            ? currentSetId
            : setStand.keys.last;
      } else {
        throw DartGameException('Failed to fetch set stand');
      }

      setState(() {});

      // Check of de wedstrijd voorbij is
      final endOfMatchResult =
          await _gameService.getEndOfMatchResult(widget.matchId);
      final loserName = endOfMatchResult['loser_name'];
      if (loserName != null && loserName.isNotEmpty) {
        // Navigeer naar de EndOfMatchView
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => EndOfMatchView(
            matchId: widget.matchId,
            onQuitAndSave: () {
              // Voer hier de logica uit om de wedstrijd af te sluiten en op te slaan
            },
          ),
        ));
      }
    } catch (e) {
      print('Failed to fetch game details: $e');
      // Handle errors
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Gameplay', style: TextStyle(color: Colors.white)),
      ),
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/bg.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Column(
            children: [
              Expanded(
                child: MatchStatus(matchId: widget.matchId),
              ),
              Expanded(
                child: ScoreInput(
                  matchId: widget.matchId,
                  currentLegId: currentLegId,
                  currentPlayerId: currentPlayerId, 
                  currentSetId: '',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
