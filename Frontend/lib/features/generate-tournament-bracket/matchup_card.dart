import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'player_card.dart';

class MatchupCard extends StatefulWidget {
  final int roundNumber;
  final int matchIndex;
  final bool canSelectPlayer;

  const MatchupCard({
    super.key,
    required this.roundNumber,
    required this.matchIndex,
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

  void checkForPlayers({
    String firstPlayerName = "",
    String secondPlayerName = "",
  }) async {
    TournamentStore store = context.read<TournamentStore>();
    Match match = store.rounds[widget.roundNumber]![widget.matchIndex];

    // Get first player
    if (match.player1Id != null && widget.canSelectPlayer) {
      try {
        Map<String, dynamic> firstPlayerResponse =
            await store.getPlayerById(match.player1Id!);
        firstPlayer = PlayerModel.fromJson(firstPlayerResponse);
      } catch (e) {
        throw Exception("The player with id ${match.player1Id} was not found");
      }
    } else {
      firstPlayer = PlayerModel.placeholderPlayer(lastName: firstPlayerName);
    }

    // Get second player
    if (match.player2Id != null && widget.canSelectPlayer) {
      try {
        Map<String, dynamic> secondPlayerResponse =
            await store.getPlayerById(match.player2Id!);
        secondPlayer = PlayerModel.fromJson(secondPlayerResponse);
      } catch (e) {
        throw Exception("The player with id ${match.player2Id} was not found");
      }
    } else {
      secondPlayer = PlayerModel.placeholderPlayer(lastName: secondPlayerName);
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    TournamentStore store = context.read<TournamentStore>();
    Match match = store.rounds[widget.roundNumber]![widget.matchIndex];

    checkForPlayers(
      firstPlayerName:
          (match.player1LastName != "" ? match.player1LastName! : ""),
      secondPlayerName:
          (match.player2LastName != "" ? match.player2LastName! : ""),
    );

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
                    roundNumber: widget.roundNumber,
                    matchIndex: widget.matchIndex,
                    player: firstPlayer,
                    isFirstPlayer: true,
                  ),
                  const SizedBox(height: 8),
                  PlayerCard(
                    canSelectPlayer: widget.canSelectPlayer,
                    roundNumber: widget.roundNumber,
                    matchIndex: widget.matchIndex,
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
