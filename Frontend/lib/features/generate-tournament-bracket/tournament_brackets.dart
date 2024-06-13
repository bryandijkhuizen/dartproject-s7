import 'package:darts_application/features/generate-tournament-bracket/round_card.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class TournamentBrackets extends StatelessWidget {
  const TournamentBrackets({super.key});

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
