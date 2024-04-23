// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleLargeWhite = theme.textTheme.titleLarge?.copyWith(
      color: Colors.white,
    );
    var titleMediumWhite =
        theme.textTheme.titleMedium?.copyWith(color: Colors.white);
    var bodyMediumWhite =
        theme.textTheme.bodyMedium?.copyWith(color: Colors.white);

    return Center(
      child: Container(
        width: 900.00,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Edit tournament",
                style: titleLargeWhite,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Review the proposed matches.",
                style: bodyMediumWhite,
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 20.0),
              child: Text(
                "Matches",
                style: titleMediumWhite,
              ),
            ),
            TournamentBracket(
                tournamentPlayers: tournamentPlayers,
                bodyMediumWhite: bodyMediumWhite),
          ],
        ),
      ),
    );
  }
}

class TournamentBracket extends StatelessWidget {
  const TournamentBracket({
    super.key,
    required this.tournamentPlayers,
    required this.bodyMediumWhite,
  });

  final List<String> tournamentPlayers;
  final TextStyle? bodyMediumWhite;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    return Container(
      color: Colors.white,
      height: 400,
      width: 500,
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: tournamentPlayers.length,
          itemBuilder: (context, index) {
            return playerCard(
                playerName: tournamentPlayers[index],
                bodyMediumWhite: bodyMediumWhite);
          },
        ),
      ),
    );
  }
}

class playerCard extends StatelessWidget {
  playerCard({
    super.key,
    required this.playerName,
    required this.bodyMediumWhite,
  });

  String playerName;
  final String avatar = "assets/images/avatar_placeholder.png";
  final TextStyle? bodyMediumWhite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(radius: 30, backgroundImage: AssetImage(avatar)),
          SizedBox(width: 16),
          // SvgPicture.asset(
          //   width: 50,
          //   height: 50,
          //   avatar,
          //   semanticsLabel: 'Avatar from player',
          // ),
          Text(
            playerName,
            // style: bodyMediumWhite,
          ),
        ],
      ),
    );
  }
}
