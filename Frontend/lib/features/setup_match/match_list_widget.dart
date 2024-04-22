import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchListWidget extends StatelessWidget {
  Future<List<dynamic>> fetchMatches() async {
    // filter on data
    final matchResponse = await Supabase.instance.client
        .from('match')
        .select()
        .order('date', ascending: true);

    List<String> playerIds = [];
    for (var match in matchResponse) {
      playerIds.add(match['player_1_id']);
      playerIds.add(match['player_2_id']);
    }

    final userResponse = await Supabase.instance.client.rpc('get_all_users');

    // Map player IDs to last names for easy access
    Map<String, String> players = {};
    for (var user in userResponse) {
      players[user['id']] = user['last_name'];
    }

    // Map player IDs to last names for each match
    List<dynamic> matches = [];
    for (var match in matchResponse) {
      matches.add({
        'id': match['id'],
        'player_1_last_name': players[match['player_1_id']],
        'player_2_last_name': players[match['player_2_id']],
      });
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Matches', style: TextStyle(color: Colors.white)),
        backgroundColor: const Color(0xFFCD0612),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: FutureBuilder<List<dynamic>>(
          future: fetchMatches(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
              return ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 64.0),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  final match = snapshot.data![index];
                  final matchId = match['id'];
                  final player1LastName =
                      match['player_1_last_name'] ?? 'Unknown';
                  final player2LastName =
                      match['player_2_last_name'] ?? 'Unknown';
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 4.0, horizontal: 16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        context.go('/matches/$matchId');
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFCD0612),
                        foregroundColor: Colors.white,
                        padding:
                            EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      child: Text(
                        'Match $matchId: $player1LastName vs $player2LastName',
                        style: TextStyle(fontSize: 14),
                        overflow: TextOverflow
                            .ellipsis, // Ensures text does not overflow the button boundary
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(child: Text('No matches found.'));
            }
          },
        ),
      ),
    );
  }
}
