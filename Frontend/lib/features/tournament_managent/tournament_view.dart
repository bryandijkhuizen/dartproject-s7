import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentView extends StatefulWidget {
  int tournamentId;
  TournamentView({super.key, required this.tournamentId});

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
  Future loadUsersData() {
    return Supabase.instance.client.rpc("get_tournament_matches",
        params: {'current_tournament_id': widget.tournamentId});
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
                FutureBuilder(
                    future: loadUsersData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        if (snapshot.hasError) {
                          return const Text(
                              "something went wrong while getting the roles");
                        }
                        if (snapshot.hasData) {
                          final matches = snapshot.data!;
                          return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: matches.length,
                            itemBuilder: (context, index) {
                              var match = matches[index];
                              DateTime matchDate =
                                  DateTime.parse(match['match_date']);
                              return ListTile(
                                title: Text(
                                    'Match on ${DateFormat('EEEE, MMM d, y - HH:mm').format(matchDate)}'),
                                subtitle: Text(
                                    'Location: ${match['match_location']} - ${match['player_1_name']} vs ${match['player_2_name']}'),
                              );
                            },
                          );
                        }
                      }
                      return const CircularProgressIndicator();
                    })
              ],
            ),
          ))),
    );
  }
}
