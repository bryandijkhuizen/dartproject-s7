import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'player_card.dart';

class MatchupCard extends StatefulWidget {
  final MatchModel match;
  final bool canSelectPlayer;

  const MatchupCard({
    super.key,
    required this.match,
    required this.canSelectPlayer,
  });

  @override
  State<MatchupCard> createState() => _MatchupCardState();
}

class _MatchupCardState extends State<MatchupCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  PlayerModel? firstPlayer;
  PlayerModel? secondPlayer;

  void checkForPlayers(
    TournamentStore tournamentStore, {
    String firstPlayerName = "",
    String secondPlayerName = "",
  }) async {
    // Get first player
    if (widget.match.player1Id.isNotEmpty && widget.canSelectPlayer) {
      try {
        Map<String, dynamic> firstPlayerResponse =
            await tournamentStore.getPlayerById(widget.match.player1Id);
        firstPlayer = PlayerModel.fromJson(firstPlayerResponse);
      } catch (e) {
        throw Exception(
            "The player with id ${widget.match.player1Id} was not found");
      }
    } else {
      firstPlayer = PlayerModel.placeholderPlayer(lastName: firstPlayerName);
    }

    // Get second player
    if (widget.match.player2Id.isNotEmpty && widget.canSelectPlayer) {
      try {
        Map<String, dynamic> secondPlayerResponse =
            await tournamentStore.getPlayerById(widget.match.player2Id);
        secondPlayer = PlayerModel.fromJson(secondPlayerResponse);
      } catch (e) {
        throw Exception(
            "The player with id ${widget.match.player2Id} was not found");
      }
    } else {
      secondPlayer = PlayerModel.placeholderPlayer(lastName: secondPlayerName);
    }
  }

  void unselectPlayer(
    TournamentStore tournamentStore,
    bool isFirstPlayer,
    PlayerModel player,
  ) {
    if (isFirstPlayer) {
      setState(() {
        firstPlayer = null;
      });
      // Remove player from match
      widget.match.player1Id = "";
      widget.match.player1LastName = "";

      tournamentStore.unselectPlayer(player.id, widget.match.id, isFirstPlayer);
    } else {
      setState(() {
        secondPlayer = null;
      });

      // Remove player from match
      widget.match.player2Id = "";
      widget.match.player2LastName = "";

      tournamentStore.unselectPlayer(player.id, widget.match.id, isFirstPlayer);
    }
  }

  void selectPlayer(
    TournamentStore tournamentStore,
    bool isFirstPlayer,
    PlayerModel player,
  ) {
    if (isFirstPlayer) {
      setState(() {
        firstPlayer = player;
      });
      widget.match.player1Id = player.id;
      widget.match.player1LastName = player.lastName;

      tournamentStore.selectPlayer(player.id, widget.match.id, isFirstPlayer);
    } else {
      setState(() {
        secondPlayer = player;
      });
      widget.match.player2Id = player.id;
      widget.match.player2LastName = player.lastName;

      tournamentStore.selectPlayer(player.id, widget.match.id, isFirstPlayer);
    }
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();

    if (widget.match.player1LastName.isNotEmpty) {
      print("First player is:  ${widget.match.player1LastName}");
    } else {
      print("No first player");
    }
    checkForPlayers(
      tournamentStore,
      firstPlayerName: (widget.match.player1LastName.isNotEmpty
          ? widget.match.player1LastName
          : ""),
      secondPlayerName: (widget.match.player2LastName.isNotEmpty
          ? widget.match.player2LastName
          : ""),
    ); // Add that if this.player1LastName is set, it should be added.

    var theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: Card(
        color: theme.colorScheme.primary,
        child: Row(
          children: [
            const SizedBox(width: 4),
            Expanded(
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  PlayerCard(
                    canSelectPlayer: widget.canSelectPlayer,
                    selectPlayerFunction: selectPlayer,
                    unselectPlayerFunction: unselectPlayer,
                    player: firstPlayer,
                    isFirstPlayer: true,
                  ),
                  const SizedBox(height: 8),
                  PlayerCard(
                    canSelectPlayer: widget.canSelectPlayer,
                    selectPlayerFunction: selectPlayer,
                    unselectPlayerFunction: unselectPlayer,
                    player: secondPlayer,
                    isFirstPlayer: false,
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
            const SizedBox(width: 4),
            ElevatedButton(
              child: const Text("Edit"),
              onPressed: () => {},
            ),
            const SizedBox(width: 8),
          ],
        ),
      ),
    );
  }
}
