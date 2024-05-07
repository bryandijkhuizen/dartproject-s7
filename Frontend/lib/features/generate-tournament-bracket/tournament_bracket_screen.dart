// ignore_for_file: prefer_const_constructors

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'tournament_brackets.dart';

class Player {
  final String name;
  final String avatarUrl;

  Player(this.name, this.avatarUrl);
}

class TournamentBracketScreen extends StatelessWidget {
  final List<String> tournamentPlayers = [
    "Michael van Gerwen",
    "Peter Wright",
    "Gerwyn Price",
    "Rob Cross",
    "Gary Anderson",
    "Nathan Aspinall",
    "Dimitri Van den Bergh",
    "James Wade",
    "Dave Chisnall",
    "Michael Smith",
    "José de Sousa",
    "Jonny Clayton",
    "Daryl Gurney",
    "Mensur Suljovic",
    "Devon Petersen",
    "Danny Noppert",
  ];

  TournamentBracketScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleLargeWhite = theme.textTheme.titleLarge?.copyWith(
      color: Colors.white,
    );
    var titleMediumWhite =
        theme.textTheme.titleMedium?.copyWith(color: Colors.white);

    const String avatarUrl = "assets/images/avatar_placeholder.png";
    List<Player> players = [];

    for (var tournamentPlayer in tournamentPlayers) {
      players.add(Player(tournamentPlayer, avatarUrl));
    }

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: 1200.00,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 30),
                  Container(
                    child: Text(
                      "Edit tournament",
                      style: titleLargeWhite,
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "Review the proposed matches.",
                    ),
                  ),
                  SizedBox(height: 20),
                  Container(
                    child: Text(
                      "Matches",
                      style: titleMediumWhite,
                    ),
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        child: Text("Fill in random"),
                        onPressed: () => {},
                      ),
                      Spacer(),
                      ElevatedButton(
                        child: Text("Clear"),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  TournamentBrackets(
                    context: context,
                    players: players,
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      ElevatedButton(
                        child: Text("Create"),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
