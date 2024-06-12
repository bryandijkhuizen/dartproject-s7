import 'package:darts_application/features/generate-tournament-bracket/matchup_card.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class RoundCard extends StatelessWidget {
  const RoundCard({
    super.key,
    required this.roundNumber,
    required this.matches,
    required this.canSelectPlayer,
  });

  final int roundNumber;
  final List<Match> matches;
  final bool canSelectPlayer;

  @override
  Widget build(BuildContext context) {
    TournamentStore store = context.read<TournamentStore>();
    final ScrollController scrollController = ScrollController();

    return Row(
      children: [
        const SizedBox(width: 4),
        Column(
          children: [
            Text(
              "Round ${roundNumber.toString()}",
            ),
            Container(
              color: Colors.white,
              height: 400,
              width: 400,
              child: Scrollbar(
                controller: scrollController,
                child: ListView.builder(
                  addAutomaticKeepAlives: true,
                  controller: scrollController,
                  scrollDirection: Axis.vertical,
                  itemCount: store.rounds[roundNumber]!.length,
                  itemBuilder: (context, index) {
                    return MatchupCard(
                      roundNumber: roundNumber,
                      matchIndex: index,
                      canSelectPlayer: canSelectPlayer,
                    );
                  },
                ),
              ),
            ),
          ],
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}
