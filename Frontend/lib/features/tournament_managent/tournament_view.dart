import 'package:darts_application/features/create_match/single_match/edit_single_match_page.dart';
import 'package:darts_application/features/setup_match/start_match.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/permissions.dart';
import 'package:darts_application/models/tournament_rounds.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:darts_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class TournamentView extends StatefulWidget {
  final int tournamentId;
  final int? clubId;
  TournamentView({Key? key, required this.tournamentId, this.clubId})
      : super(key: key);

  @override
  _TournamentViewState createState() => _TournamentViewState();
}

class _TournamentViewState extends State<TournamentView> {
  Future<Tournament> loadUsersData() async {
    var result = await Supabase.instance.client.rpc("get_tournament_matches",
        params: {'current_tournament_id': widget.tournamentId});
    var rounds = Tournament.fromJson(result);

    return rounds;
  }

  @override
  Widget build(BuildContext context) {
    UserStore userStore = context.read();
    Permissions permissions = userStore.permissions;
    return Scaffold(
      appBar: AppBar(title: const Text('Tournament name')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                FutureBuilder<Tournament>(
                  future: loadUsersData(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasError) {
                        return const Text("Something went wrong");
                      }
                      if (snapshot.hasData) {
                        Tournament tournament = snapshot.data!;
                        List<Widget> pageList = [];
                        for (TournamentRound round in tournament.rounds) {
                          pageList.add(Text(round.roundHeader));

                          pageList.add(
                            ListView.builder(
                              physics: const NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              itemCount: round.matches.length,
                              itemBuilder: (context, index) {
                                var match = round.matches[index];
                                return ListTile(
                                  title: Text(
                                      '${match.player1LastName} vs ${match.player1LastName} - Location: ${match.location}'),
                                  subtitle: Text(
                                      'Match on ${DateFormat('EEEE, MMM d, y - HH:mm').format(match.date)}'),
                                  trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children:
                                          BuildTrailButton(permissions, match)),
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

  List<Widget> BuildTrailButton(Permissions permissions, Match match) {
    List<Widget> trail = [];

    int? clubId = widget.clubId;

    // Null check for clubId
    if (clubId == null) {
      // Check for system permissions and add buttons accordingly
      if (match.player1Id != null && match.player2Id != null) {
        if (permissions.systemPermissions
            .contains(PermissionList.markInTournament.permissionName)) {
          trail.add(IconButton(
            color: darkColorScheme.onSecondary,
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StartMatch(
                    matchId: match.id.toString(),
                    isDesktop: true,
                  ),
                ),
              );
            },
          ));
        }
      }
      if (permissions.systemPermissions
          .contains(PermissionList.updateTournament.permissionName)) {
        trail.add(IconButton(
          color: darkColorScheme.onSecondary,
          icon: const Icon(Icons.edit),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    EditSingleMatchPage(match: match.toJson()),
              ),
            );
          },
        ));
      }
    } else {
      // Check club permissions and add buttons accordingly
      if (match.player1Id != null && match.player2Id != null) {
        if (permissions
                .getClubIdByPermission(PermissionList.markInClubTournament) ==
            clubId) {
          trail.add(IconButton(
            color: darkColorScheme.onSecondary,
            icon: const Icon(Icons.play_arrow),
            onPressed: () async {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => StartMatch(
                    matchId: match.id.toString(),
                    isDesktop: false,
                  ),
                ),
              );
            },
          ));
        }
      }
      if (permissions
              .getClubIdByPermission(PermissionList.updateClubTournament) ==
          clubId) {
        trail.add(IconButton(
          color: darkColorScheme.onSecondary,
          icon: const Icon(Icons.edit),
          onPressed: () async {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    EditSingleMatchPage(match: match.toJson()),
              ),
            );
          },
        ));
      }
    }
    return trail;
  }
}
