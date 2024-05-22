// ignore_for_file: prefer_const_constructors

import 'package:darts_application/features/generate-tournament-bracket/tournament_bracket_screen.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'matchup_card.dart';

// class TournamentBrackets extends StatelessWidget {
  // TournamentBrackets({
  //   super.key,
  //   required this.context,
  //   required this.players,
  // });

  // final BuildContext context;
  // final List<Player> players;
  // final String avatarUrl = "assets/images/avatar_placeholder.png";

  // final List<String> playerIds = [
  //   "d9f932b0-242b-40e5-b315-71946e74e728",
  //   "b58264e3-60d7-473c-8192-bde60f8ffc9d",
  //   "73d4b35f-1019-400d-b182-e129af87e93c",
  //   "f472ea91-5abf-4084-b60f-e1f01b35b915",
  //   "b516b1d7-bf51-4b03-95c6-f33a673dba91",
  //   "e8123017-ac48-471f-8cf1-bafff5e26457",
  //   "e2f1738a-183a-4512-9ae6-c07fab252043",
  //   "a299635f-3df3-40f9-ab37-10dcf8c5874c",
  //   "ca4d4f39-3585-4a17-a0ba-9b6566c0dcc7",
  //   "f081d7b8-0d03-4f3b-9092-da0a297e7817",
  //   "bf00e9d4-dcbc-46cc-84ef-1b5f6fa4d385",
  //   "1d49f93f-a389-4bc6-817e-1393176daad0",
  //   "8b1851a2-be16-4fbf-a3aa-2c5eef41a4d6",
  //   "e93ea6ab-170f-4637-ad5c-5c693c881475",
  //   "9d615e21-6699-4d13-a68c-865b6d333cad",
  //   "01f73f6d-741c-4ef1-afd4-af145336dde2"
  // ];

  // Future loadUsersByIds(List<String> playerIds) {
  //   print("Hij zit in de future");
  //   return Supabase.instance.client
  //       .rpc("get_users_by_uuids", params: {"uuid_list": playerIds});
  // }

  // List<Widget> createRounds(List<PlayerModel> players, int round,
  //     {bool selectPlayer = false, bool fillInPlayers = false}) {
  //   List<Widget> tournamentBracket = [];
  //   List<MatchupCard> matches = createMatches(players,
  //       selectPlayer: selectPlayer, fillInPlayers: fillInPlayers);

  //   final ScrollController _scrollController = ScrollController();

  //   Widget roundLayout = Column(
  //     children: [
  //       Text(
  //         "Round ${round.toString()}",
  //       ),
  //       Container(
  //         color: Colors.white,
  //         height: 400,
  //         width: 400,
  //         child: Scrollbar(
  //           controller: _scrollController,
  //           child: ListView.builder(
  //             controller: _scrollController,
  //             scrollDirection: Axis.vertical,
  //             itemCount: matches.length,
  //             itemBuilder: (context, index) {
  //               return matches[index];
  //             },
  //           ),
  //         ),
  //       ),
  //     ],
  //   );

  //   tournamentBracket.add(roundLayout);

  //   if (matches.length > 1) {
  //     List<PlayerModel> nextRoundPlayers = [];
  //     for (var i = 1; i <= matches.length; i++) {
  //       nextRoundPlayers.add(Player("Winner match $i", avatarUrl));
  //     }

  //     List<Widget> nextRoundBracket = createRounds(nextRoundPlayers, ++round,
  //         selectPlayer: false, fillInPlayers: true);
  //     tournamentBracket.addAll(nextRoundBracket);
  //   }

  //   return tournamentBracket;
  // }

  // List<MatchupCard> createMatches(List<Player> players,
  //     {bool selectPlayer = false, bool fillInPlayers = false}) {
  //   List<MatchupCard> matches = [];
  //   Player placeholderPlayer = Player("", avatarUrl);
  //   var amountOfPlayers = players.length;
  //   var amountOfMatches = (amountOfPlayers / 2).ceil();

  //   while (amountOfMatches >= 1) {
  //     Player firstPlayer;
  //     Player secondPlayer;

  //     if (fillInPlayers) {
  //       firstPlayer =
  //           players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
  //       secondPlayer =
  //           players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
  //     } else {
  //       firstPlayer = placeholderPlayer;
  //       secondPlayer = placeholderPlayer;
  //     }

  //     matches.add(
  //       MatchupCard(
  //         firstPlayer: firstPlayer,
  //         secondPlayer: secondPlayer,
  //         selectPlayer: selectPlayer,
  //       ),
  //     );

  //     amountOfMatches--;
  //   }

  //   return matches;
  // }

  // @override
  // Widget build(BuildContext context) {
  //   TournamentStore tournamentStore = context.read<TournamentStore>();
  //   FutureBuilder(
  //       future: loadUsersByIds(playerIds),
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.done) {
  //           print("ConnectionState is Done");
  //           if (snapshot.hasError) {
  //             print("Snapshot has error");
  //             return const Text("Something went wrong!");
  //           }
  //           if (snapshot.hasData) {
  //             print("Snapshot has Data");
  //             print("It works");
  //             print(snapshot.data);
  //             print("kaas");
  //           }
  //         }
  //         print("Circular");
  //         return CircularProgressIndicator();
  //       });

  //   print("Builder werkt!");

  //   List<Widget> rounds =
  //       createRounds(players, 1, selectPlayer: true, fillInPlayers: false);

  //   return Container(
  //     margin: EdgeInsets.only(bottom: 20.0),
  //     child: SingleChildScrollView(
  //       scrollDirection: Axis.horizontal,
  //       child: Row(
  //         children: rounds,
  //       ),
  //     ),
  //   );
  // }
// }
