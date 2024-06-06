import 'package:darts_application/features/create_match/single_match/edit_single_match_page.dart';
import 'package:darts_application/models/tournament_rounds.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentView extends StatefulWidget {
  final int tournamentId;
  TournamentView({Key? key, required this.tournamentId}) : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {

  Future<TournamentRounds> loadUsersData() async {
    var result = await Supabase.instance.client.rpc("get_tournament_matches",
        params: {'current_tournament_id': widget.tournamentId});
    var rounds = TournamentRounds.fromJson(result);

    return rounds;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament name')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<TournamentRounds>(
                  future: loadUsersData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if (snapshot.hasData) {
                        TournamentRounds tournamentRounds = snapshot.data!;
                        List<Widget> pageList = [];
                        for (Round round in tournamentRounds.rounds) {
                          pageList.add(Text(round.roundHeader));

                          pageList.add(
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: round.matches.length,
                              itemBuilder: (context, index) {
                                var match = round.matches[index];
                                DateTime matchDate =
                                    DateTime.parse(match['match_date']);
                                return ListTile(
                                  title: Text(
                                      '${match['player_1_name']} vs ${match['player_2_name']} - Location: ${match['match_location']}'),
                                  subtitle: Text(
                                      'Match on ${DateFormat('EEEE, MMM d, y - HH:mm').format(matchDate)}'),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () async {
                                      // Perform the async database call
                                      final response = await Supabase
                                          .instance.client
                                          .from('match')
                                          .select()
                                          .eq("id", match["match_id"])
                                          .single();

                                      // Once the data is fetched, navigate to the next page
                                      Navigator.of(context).push(
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditSingleMatchPage(
                                                  match: response),
                                        ),
                                      );
                                    },
                                  ),
                                );
                              },
                            ),
                          );
                        }
                        return Column(children: pageList);
                      }
                    }
                    return const CircularProgressIndicator();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
