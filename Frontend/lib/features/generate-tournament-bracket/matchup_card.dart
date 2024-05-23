import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'player_card.dart';

class MatchupCard extends StatelessWidget {
  final MatchModel match;
  final bool selectPlayer;
  PlayerModel? firstPlayer;
  PlayerModel? secondPlayer;

  MatchupCard({
    super.key,
    required this.match,
    required this.selectPlayer,
  });

  void checkForPlayers(
    TournamentStore tournamentStore, {
    String firstPlayerName = "",
    String secondPlayerName = "",
  }) async {
    if (match.player1Id.isNotEmpty && selectPlayer) {
      try {
        Map<String, dynamic> firstPlayerResponse =
            await tournamentStore.getPlayerById(match.player1Id);
        firstPlayer = PlayerModel.fromJson(firstPlayerResponse);
      } catch (e) {
        throw Exception("The player with id ${match.player1Id} was not found");
      }
    } else {
      firstPlayer = PlayerModel.placeholderPlayer(firstName: firstPlayerName);
    }

    if (match.player2Id.isNotEmpty && selectPlayer) {
      try {
        Map<String, dynamic> secondPlayerResponse =
            await tournamentStore.getPlayerById(match.player2Id);
        secondPlayer = PlayerModel.fromJson(secondPlayerResponse);
      } catch (e) {
        throw Exception("The player with id ${match.player2Id} was not found");
      }
    } else {
      secondPlayer = PlayerModel.placeholderPlayer(firstName: secondPlayerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();

    checkForPlayers(tournamentStore);
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Row(
        children: [
          Expanded(
            child: Column(
              children: [
                PlayerCard(
                  player: firstPlayer,
                  selectPlayer: selectPlayer,
                ),
                PlayerCard(
                  player: secondPlayer,
                  selectPlayer: selectPlayer,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: const Text("Edit"),
            onPressed: () => {},
          ),
          const SizedBox(width: 8),
        ],
      ),
    );
  }
}
