import 'package:darts_application/features/create_match/single_match/create_single_match_page.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/features/setup_match/match_list.dart';

class MatchListWidget extends StatefulWidget {
  const MatchListWidget({super.key});

  @override
  _MatchListWidgetState createState() => _MatchListWidgetState();
}

class _MatchListWidgetState extends State<MatchListWidget> {
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
        await Supabase.instance.client.rpc('get_pending_matches');
    final matchResponseActive =
        await Supabase.instance.client.rpc('get_active_matches');

    matchResponsePending.removeWhere((match) => match['winner_id'] != null);
    matchResponseActive.removeWhere((match) => match['winner_id'] != null);

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

    final pendingMatches = mapMatches(matchResponsePending);
    final activeMatches = mapMatches(matchResponseActive);

    return {
      'pending_matches': pendingMatches,
      'active_matches': activeMatches,
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
        child: Column(
          children: [
            FutureBuilder<Map<String, List<MatchModel>>>(
              future: _matchesFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final pendingMatches = snapshot.data!['pending_matches']!;
                  final activeMatches = snapshot.data!['active_matches']!;
                  return Expanded(
                    child: ListView(
                      children: [
                        MatchList(
                          title: 'Pending Matches',
                          matches: pendingMatches,
                        ),
                        MatchList(
                          title: 'Active Matches',
                          matches: activeMatches,
                        ),
                      ],
                    ),
                  );
                } else {
                  return const Center(child: Text('No matches found.'));
                }
              },
            ),
            Padding(
              padding: const EdgeInsets.only(
                  bottom: 16.0), // Add margin at the bottom
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const CreateSingleMatchPage()));
                },
                child: const Text('Create Match'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
