// ignore_for_file: prefer_const_constructors

import 'package:darts_application/features/generate-tournament-bracket/tournament_bracket_screen.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/widgets.dart';

import 'player_card.dart';

// class MatchupCard extends StatelessWidget {
//   final Player firstPlayer;
//   final Player secondPlayer;
//   final bool selectPlayer;

//   const MatchupCard({
//     super.key,
//     required this.firstPlayer,
//     required this.secondPlayer,
//     required this.selectPlayer,
//   });

//   @override
//   Widget build(BuildContext context) {
//     TournamentStore tournamentStore = context.read<TournamentStore>();
//     var theme = Theme.of(context);
//     return Card(
//       color: theme.colorScheme.primary,
//       child: Row(
//         children: [
//           Expanded(
//             child: Column(
//               children: [
//                 PlayerCard(
//                   player: firstPlayer,
//                   selectPlayer: selectPlayer,
//                 ),
//                 PlayerCard(
//                   player: secondPlayer,
//                   selectPlayer: selectPlayer,
//                 ),
//               ],
//             ),
//           ),
//           ElevatedButton(
//             child: Text("Edit"),
//             onPressed: () => {},
//           ),
//           SizedBox(width: 8),
//         ],
//       ),
//     );
//   }
// }
