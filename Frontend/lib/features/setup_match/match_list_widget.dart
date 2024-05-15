// ignore_for_file: use_build_context_synchronously, use_key_in_widget_constructors

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';

class MatchListWidget extends StatelessWidget {
  const MatchListWidget({Key? key});

  Future<Map<String, List<MatchModel>>> fetchMatches() async {
    final matchResponsePending =
        await Supabase.instance.client.rpc('get_pending_matches');
    final matchResponseActive =
        await Supabase.instance.client.rpc('get_active_matches');

    List<MatchModel> pendingMatches = matchResponsePending
        .map<MatchModel>((match) => MatchModel.fromJson(match))
        .toList();

    List<MatchModel> activeMatches = matchResponseActive
        .map<MatchModel>((match) => MatchModel.fromJson(match))
        .toList();

    final userResponse = await Supabase.instance.client.rpc('get_users');
    List<PlayerModel> players = userResponse
        .map<PlayerModel>((user) => PlayerModel.fromJson(user))
        .toList();

    for (var match in pendingMatches) {
      match.player1LastName =
          players.firstWhere((player) => player.id == match.player1Id).lastName;
      match.player2LastName =
          players.firstWhere((player) => player.id == match.player2Id).lastName;
    }

    for (var match in activeMatches) {
      match.player1LastName =
          players.firstWhere((player) => player.id == match.player1Id).lastName;
      match.player2LastName =
          players.firstWhere((player) => player.id == match.player2Id).lastName;
    }

    return {
      'pending_matches': pendingMatches,
      'active_matches': activeMatches,
    };
  }

  Future<bool> matchAlreadyStarted(matchID) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_sets_by_match_id', params: {'current_match_id': matchID});

      return response.isNotEmpty;
    } catch (e) {
      throw Exception('Failed to check if match already started: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches', style: TextStyle(color: Colors.white)),
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<Map<String, List<MatchModel>>>(
          future: fetchMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData) {
              final pendingMatches = snapshot.data!['pending_matches']!;
              final activeMatches = snapshot.data!['active_matches']!;
              return ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Pending Matches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const Divider(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: pendingMatches.length,
                        itemBuilder: (context, index) {
                          final match = pendingMatches[index];
                          final matchId = match.id;
                          final player1LastName = match.player1LastName;
                          final player2LastName = match.player2LastName;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (await matchAlreadyStarted(matchId)) {
                                  context.go('/gameplay/$matchId');
                                } else {
                                  context.go('/matches/$matchId');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCD0612),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Match $matchId: $player1LastName vs $player2LastName',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow
                                    .ellipsis, // Ensures text does not overflow the button boundary
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(top: 16.0),
                        child: Text(
                          'Active Matches',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.75,
                        child: const Divider(),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: activeMatches.length,
                        itemBuilder: (context, index) {
                          final match = activeMatches[index];
                          final matchId = match.id;
                          final player1LastName = match.player1LastName;
                          final player2LastName = match.player2LastName;

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4.0, horizontal: 16.0),
                            child: ElevatedButton(
                              onPressed: () async {
                                if (await matchAlreadyStarted(matchId)) {
                                  context.go('/gameplay/$matchId');
                                } else {
                                  context.go('/matches/$matchId');
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFCD0612),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: Text(
                                'Match $matchId: $player1LastName vs $player2LastName',
                                style: const TextStyle(fontSize: 14),
                                overflow: TextOverflow
                                    .ellipsis, // Ensures text does not overflow the button boundary
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              );
            } else {
              return const Center(child: Text('No matches found.'));
            }
          },
        ),
      ),
    );
  }
}
