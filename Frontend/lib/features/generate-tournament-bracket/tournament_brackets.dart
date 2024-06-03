import 'package:darts_application/features/generate-tournament-bracket/round_card.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import 'matchup_card.dart';

class TournamentBrackets extends StatelessWidget {
  const TournamentBrackets({super.key});

  // List<Widget> createRounds(
  //   TournamentStore tournamentStore,
  //   List<PlayerModel> players,
  //   int round, {
  //   bool canSelectPlayer = false,
  //   bool fillInPlayers = false,
  // }) {
  //   List<Widget> tournamentBracket = [];
  //   List<MatchupCard> matches = createMatches(
  //     tournamentStore,
  //     players,
  //     canSelectPlayer: canSelectPlayer,
  //     fillInPlayers: fillInPlayers,
  //   );

  //   Widget roundLayout =
  //       round_card(scrollController: _scrollController, matches: matches);

  //   tournamentBracket.add(roundLayout);

  //   if (matches.length > 1) {
  //     List<PlayerModel> nextRoundPlayers = [];
  //     for (var i = 1; i <= matches.length; i++) {
  //       nextRoundPlayers
  //           .add(PlayerModel.placeholderPlayer(lastName: "Winner match $i"));
  //     }

  //     List<Widget> nextRoundBracket = createRounds(
  //       tournamentStore,
  //       nextRoundPlayers,
  //       ++round,
  //       canSelectPlayer: false,
  //       fillInPlayers: true,
  //     );
  //     tournamentBracket.addAll(nextRoundBracket);
  //   }

  //   return tournamentBracket;
  // }

  // List<MatchupCard> createMatches(
  //   TournamentStore tournamentStore,
  //   List<PlayerModel> players, {
  //   bool canSelectPlayer = false,
  //   bool fillInPlayers = false,
  // }) {
  //   PlayerModel placeholderPlayer = PlayerModel.placeholderPlayer();
  //   List<MatchupCard> matches = [];
  //   var amountOfPlayers = players.length;
  //   var amountOfMatches = (amountOfPlayers / 2).ceil();

  //   if (amountOfPlayers < 1 || amountOfMatches < 1) {
  //     throw Exception("Not enough players where found to create a match");
  //   }

  //   while (amountOfMatches >= 1) {
  //     PlayerModel firstPlayer;
  //     PlayerModel secondPlayer;

  //     if (fillInPlayers) {
  //       firstPlayer =
  //           players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
  //       secondPlayer =
  //           players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
  //     } else {
  //       firstPlayer = placeholderPlayer;
  //       secondPlayer = placeholderPlayer;
  //     }

  //     MatchModel newMatch = tournamentStore.addMatch(
  //       firstPlayer,
  //       secondPlayer,
  //       DateTime.now().add(const Duration(days: 1)),
  //       501, // Get this information from tournament settings page
  //       5,
  //     );

  //     matches.add(
  //       MatchupCard(
  //         match: newMatch,
  //         canSelectPlayer: canSelectPlayer,
  //       ),
  //     );

  //     amountOfMatches--;
  //   }

  //   return matches;
  // }

  @override
  Widget build(BuildContext context) {
    TournamentStore store = context.read<TournamentStore>();

    return Observer(builder: (context) {
      if (!store.initialized) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      } else {
        return Container(
          margin: const EdgeInsets.only(bottom: 20.0),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: store.rounds.entries.map((round) {
                bool canSelectPlayer = round.key == 1 ? true : false;
                return RoundCard(
                  roundNumber: round.key,
                  matches: round.value,
                  canSelectPlayer: canSelectPlayer,
                );
              }).toList(),
            ),
          ),
        );
      }
    });
  }
}
