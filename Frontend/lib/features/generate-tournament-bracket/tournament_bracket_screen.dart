// ignore_for_file: prefer_const_constructors

import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:supabase/supabase.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/player.dart';

import 'tournament_brackets.dart';

class TournamentBracketScreen extends StatelessWidget {
  List<PlayerModel> players;

  TournamentBracketScreen({
    super.key,
    List<PlayerModel>? players,
  }) : players = players ?? [];

  void checkPlayers(TournamentStore tournamentStore) async {
    if (players.isEmpty) {
      // For now use test data
      final List<String> playerIds = [
        "d9f932b0-242b-40e5-b315-71946e74e728",
        "b58264e3-60d7-473c-8192-bde60f8ffc9d",
        "73d4b35f-1019-400d-b182-e129af87e93c",
        "f472ea91-5abf-4084-b60f-e1f01b35b915",
        "b516b1d7-bf51-4b03-95c6-f33a673dba91",
        "e8123017-ac48-471f-8cf1-bafff5e26457",
        "e2f1738a-183a-4512-9ae6-c07fab252043",
        "a299635f-3df3-40f9-ab37-10dcf8c5874c",
        "ca4d4f39-3585-4a17-a0ba-9b6566c0dcc7",
        "f081d7b8-0d03-4f3b-9092-da0a297e7817",
        "bf00e9d4-dcbc-46cc-84ef-1b5f6fa4d385",
        "1d49f93f-a389-4bc6-817e-1393176daad0",
        "8b1851a2-be16-4fbf-a3aa-2c5eef41a4d6",
        "e93ea6ab-170f-4637-ad5c-5c693c881475",
        "9d615e21-6699-4d13-a68c-865b6d333cad",
        "01f73f6d-741c-4ef1-afd4-af145336dde2"
      ];

      players = await tournamentStore.loadPlayersByIds(playerIds);
    }

    tournamentStore.unselectedPlayers = players;
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleLargeWhite = theme.textTheme.titleLarge?.copyWith(
      color: Colors.white,
    );
    var titleMediumWhite =
        theme.textTheme.titleMedium?.copyWith(color: Colors.white);

    // const String avatarUrl = "assets/images/avatar_placeholder.png";
    // List<Player> players = [];

    // for (var tournamentPlayer in tournamentPlayers) {
    //   players.add(Player(tournamentPlayer, avatarUrl));
    // }

    return Provider(
      create: (context) => TournamentStore(Supabase.instance.client),
      child: Builder(builder: (context) {
        TournamentStore tournamentStore = context.read<TournamentStore>();
        // if (!tournamentStore.initialized) {
        //   return const CircularProgressIndicator();
        // }

        checkPlayers(tournamentStore);

        return ListView(
          scrollDirection: Axis.vertical,
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: SizedBox(
                  width: 1200.00,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 30),
                      Container(
                        child: Text(
                          "Edit tournament",
                          style: titleLargeWhite,
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "Review the proposed matches.",
                        ),
                      ),
                      SizedBox(height: 20),
                      Container(
                        child: Text(
                          "Matches",
                          style: titleMediumWhite,
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          ElevatedButton(
                            child: Text("Fill in random"),
                            onPressed: () => {},
                          ),
                          Spacer(),
                          ElevatedButton(
                            child: Text("Clear"),
                            onPressed: () => {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      // TournamentBrackets(
                      //   context: context,
                      //   players: players,
                      // ),
                      SizedBox(height: 20),
                      Row(
                        children: [
                          Spacer(),
                          ElevatedButton(
                            child: Text("Create"),
                            onPressed: () => {},
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
