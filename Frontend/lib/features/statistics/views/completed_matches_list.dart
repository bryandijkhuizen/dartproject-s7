import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/features/setup_match/match_list.dart';

class CompletedMatchesListWidget extends StatefulWidget {
  const CompletedMatchesListWidget({super.key});

  @override
  _CompletedMatchesListWidgetState createState() =>
      _CompletedMatchesListWidgetState();
}

class _CompletedMatchesListWidgetState
    extends State<CompletedMatchesListWidget> {
  late Future<Map<String, List<MatchModel>>> _matchesFuture;

  @override
  void initState() {
    super.initState();
    _matchesFuture = fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _matchesFuture = fetchMatches();
    });
  }

  Future<Map<String, List<MatchModel>>> fetchMatches() async {
    final matchResponsePending =
        await Supabase.instance.client.rpc('get_completed_matches');

    final userResponse = await Supabase.instance.client.rpc('get_users');
    List<PlayerModel> players = userResponse
        .map<PlayerModel>((user) => PlayerModel.fromJson(user))
        .toList();

    List<MatchModel> mapMatches(List<dynamic> matchResponse) {
      return matchResponse
          .map<MatchModel>((match) => MatchModel.fromJson(match))
          .map((match) {
        match.player1LastName = players
            .firstWhere((player) => player.id == match.player1Id)
            .lastName;
        match.player2LastName = players
            .firstWhere((player) => player.id == match.player2Id)
            .lastName;
        return match;
      }).toList();
    }

    final completedMatches = mapMatches(matchResponsePending);

    return {
      'completed_matches': completedMatches,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMatches,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
