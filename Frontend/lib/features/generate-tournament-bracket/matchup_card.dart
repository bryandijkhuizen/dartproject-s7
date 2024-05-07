// ignore_for_file: prefer_const_constructors

import 'package:darts_application/features/generate-tournament-bracket/tournament_bracket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'player_card.dart';

class MatchupCard extends StatelessWidget {
  final Player firstPlayer;
  final Player secondPlayer;

  const MatchupCard({
    super.key,
    required this.firstPlayer,
    required this.secondPlayer,
  });

  @override
  Widget build(BuildContext context) {
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
                ),
                PlayerCard(
                  player: secondPlayer,
                ),
              ],
            ),
          ),
          ElevatedButton(
            child: Text("Edit"),
            onPressed: () => {},
          ),
          SizedBox(width: 8)
        ],
      ),
    );
  }
}
