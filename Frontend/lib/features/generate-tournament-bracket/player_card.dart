// ignore_for_file: prefer_const_constructors

import 'package:darts_application/features/generate-tournament-bracket/tournament_bracket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.player,
  });

  final Player player;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        children: [
          SizedBox(width: 4),
          CircleAvatar(
              radius: 20, backgroundImage: AssetImage(player.avatarUrl)),
          SizedBox(width: 8),
          Expanded(
            child: Text(
              player.name,
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
