import 'package:darts_application/features/tournament_managent/tournament_view.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:intl/intl.dart';
import 'package:darts_application/features/create_match/create_single_match_page.dart';
import 'package:darts_application/features/create_match/edit_single_match_page.dart';
import 'package:darts_application/features/generate-tournament-bracket/views/tournament_bracket_screen.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/features/create_tournament/create_tournament_page.dart';

class UpcomingMatchesPage extends StatefulWidget {
  const UpcomingMatchesPage({super.key});

  @override
  State<UpcomingMatchesPage> createState() => _UpcomingMatchesPageState();
}

class _UpcomingMatchesPageState extends State<UpcomingMatchesPage> {
  late Future<List<Map<String, dynamic>>> upcomingMatches;
  late Future<List<Map<String, dynamic>>> upcomingTournaments;
  late Future<List<PlayerModel>> players;

  @override
  void initState() {
    super.initState();
    upcomingMatches = fetchUpcomingMatches();
    upcomingTournaments = fetchUpcomingTournaments();
    players = fetchPlayers();
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingMatches() async {
    final response = await Supabase.instance.client
        .from('match')
        .select()
        .gte('date', DateTime.now().toIso8601String())
        .order('date', ascending: true);
    var filteredMatches =
        response.where((match) => match['player_1_id'] != null).toList();
    return List<Map<String, dynamic>>.from(filteredMatches);
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingTournaments() async {
    final response = await Supabase.instance.client.from('tournament').select();

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<PlayerModel>> fetchPlayers() async {
    final response = await Supabase.instance.client.from('user').select();
    return response
        .map<PlayerModel>((player) => PlayerModel.fromJson(player))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: <Widget>[
          IconButton(
              onPressed: () {
                setState(() {
                  upcomingMatches = fetchUpcomingMatches();
                  upcomingTournaments = fetchUpcomingTournaments();
                  players = fetchPlayers();
                });
              },
              icon: const Icon(Icons.refresh)),
          TextButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => const CreateSingleMatchPage())),
            child: const Text('Create Match',
                style: TextStyle(color: Colors.white)),
          ),
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateTournamentPage())),
            child: const Text('Create Tournament', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Single matches', style: TextStyle(fontSize: 16)),
            ),
            FutureBuilder<List<dynamic>>(
              future: Future.wait([upcomingMatches, players]),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final matches =
                      snapshot.data![0] as List<Map<String, dynamic>>;
                  final playersList = snapshot.data![1] as List<PlayerModel>;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      var match = matches[index];
                      DateTime matchDate = DateTime.parse(match['date']);
                      var player1 = playersList.firstWhere(
                          (player) => player.id == match['player_1_id']);
                      var player2 = playersList.firstWhere(
                          (player) => player.id == match['player_2_id']);
                      return ListTile(
                        title: Text(
                            'Match on ${DateFormat('EEEE, MMM d, y - HH:mm').format(matchDate)}'),
                        subtitle: Text(
                            'Location: ${match['location']} - ${player1.lastName} vs ${player2.lastName}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    EditSingleMatchPage(match: match),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No upcoming matches found'));
                }
              },
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Text('Tournaments', style: TextStyle(fontSize: 16)),
            ),
            FutureBuilder<List<Map<String, dynamic>>>(
              future: upcomingTournaments,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final tournaments = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: tournaments.length,
                    itemBuilder: (context, index) {
                      var tournament = tournaments[index];
                      DateTime tournamentDate =
                          DateTime.parse(tournament['start_time']);
                      return ListTile(
                        title: Text(
                            '${tournament['name']} on ${DateFormat('EEEE, MMM d, y - HH:mm').format(tournamentDate)}'),
                        subtitle: Text(
                            'Location: ${tournament['location']} - Club: ${tournament['club_id']}'),
                        trailing: TextButton(
                          child: const Text("View"),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TournamentView(
                                  tournamentId: tournament['id'],
                                  clubId: tournament['club_id'],
                                ),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else {
                  return const Center(
                      child: Text('No upcoming tournaments found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
