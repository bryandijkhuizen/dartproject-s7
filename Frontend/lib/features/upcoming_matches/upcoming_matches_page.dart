import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/features/create_match/single_match/create_single_match_page.dart';
import 'package:darts_application/features/create_match/tournament/create_tournament_page.dart';

class UpcomingMatchesPage extends StatefulWidget {
  const UpcomingMatchesPage({super.key});

  @override
  State<UpcomingMatchesPage> createState() => _UpcomingMatchesPageState();
}

class _UpcomingMatchesPageState extends State<UpcomingMatchesPage> {
  late Future<List<Map<String, dynamic>>> upcomingMatches;
  late Future<List<Map<String, dynamic>>> upcomingTournaments;

  @override
  void initState() {
    super.initState();
    upcomingMatches = fetchUpcomingMatches();
    upcomingTournaments = fetchUpcomingTournaments();
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingMatches() async {
    final response = await Supabase.instance.client
      .from('match')
      .select()
      .gte('date', DateTime.now().toIso8601String())
      .order('date', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  Future<List<Map<String, dynamic>>> fetchUpcomingTournaments() async {
    final response = await Supabase.instance.client
      .from('tournament')
      .select()
      .gte('start_time', DateTime.now().toIso8601String())
      .order('start_time', ascending: true);

    return List<Map<String, dynamic>>.from(response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Upcoming Events'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => CreateSingleMatchPage())),
            child: const Text('Create Match', style: TextStyle(color: Colors.white)),
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
            FutureBuilder<List<Map<String, dynamic>>>(
              future: upcomingMatches,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (snapshot.hasData) {
                  final matches = snapshot.data!;
                  return ListView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: matches.length,
                    itemBuilder: (context, index) {
                      var match = matches[index];
                      DateTime matchDate = DateTime.parse(match['date']);
                      return ListTile(
                        title: Text('Match on ${matchDate.toLocal()}'),
                        subtitle: Text('Location: ${match['location']} - ${match['player_1_id']} vs ${match['player_2_id']}'),
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
                      DateTime tournamentDate = DateTime.parse(tournament['start_time']);
                      return ListTile(
                        title: Text('${tournament['name']} on ${tournamentDate.toLocal()}'),
                        subtitle: Text('Location: ${tournament['location']} - Club: ${tournament['club_id']}'),
                      );
                    },
                  );
                } else {
                  return const Center(child: Text('No upcoming tournaments found'));
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
