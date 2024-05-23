import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/features/create_match/single_match/create_single_match_page.dart';

class MatchListWidget extends StatelessWidget {
  const MatchListWidget({super.key});

  Future<List<MatchModel>> fetchMatches() async {
    final matchResponse = await Supabase.instance.client.from('match').select();
    List<MatchModel> matches = matchResponse
        .map<MatchModel>((match) => MatchModel.fromJson(match))
        .toList();

    final userResponse = await Supabase.instance.client.from('user').select();
    List<PlayerModel> players = userResponse
        .map<PlayerModel>((user) => PlayerModel.fromJson(user))
        .toList();

    for (var match in matches) {
      match.player1LastName =
          players.firstWhere((player) => player.id == match.player1Id).lastName;
      match.player2LastName =
          players.firstWhere((player) => player.id == match.player2Id).lastName;
    }

    return matches;
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: FutureBuilder<List<MatchModel>>(
                future: fetchMatches(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 64.0),
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final match = snapshot.data![index];
                        final matchId = match.id;
                        final player1LastName = match.player1LastName;
                        final player2LastName = match.player2LastName;
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
                              padding: const EdgeInsets.symmetric(
                                  vertical: 8, horizontal: 12),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
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
                    );
                  } else {
                    return const Center(child: Text('No matches found.'));
                  }
                },
              ),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFCD0612),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 20),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateSingleMatchPage())),
              child: const Text('Create Match', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
