// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

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

  TournamentBracketScreen({super.key});

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

    const String avatarUrl = "assets/images/avatar_placeholder.png";
    List<Player> players = [];

    for (var tournamentPlayer in tournamentPlayers) {
      players.add(Player(tournamentPlayer, avatarUrl));
    }

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
                players: players, bodyMediumWhite: bodyMediumWhite),
          ],
        ),
      ),
    );
  }
}

class Player {
  final String name;
  final String avatarUrl;

  Player(this.name, this.avatarUrl);
}

class TournamentBracket extends StatelessWidget {
  const TournamentBracket({
    super.key,
    required this.players,
    required this.bodyMediumWhite,
  });

  final List<Player> players;
  final TextStyle? bodyMediumWhite;

  @override
  Widget build(BuildContext context) {
    final ScrollController _scrollController = ScrollController();

    List<MatchupCard> matches = [];
    Player firstPlayer = Player("", "");
    var playerCount = 0;

    for (var player in players) {
      if (playerCount == 0) {
        firstPlayer = player;
        playerCount = 1;
      } else if (playerCount == 1) {
        matches.add(MatchupCard(
            firstPlayer: firstPlayer,
            secondPlayer: player,
            bodyMediumWhite: bodyMediumWhite));
        playerCount = 0;
      }
    }

    return Container(
      color: Colors.white,
      height: 400,
      width: 500,
      child: Scrollbar(
        controller: _scrollController,
        child: ListView.builder(
          controller: _scrollController,
          scrollDirection: Axis.vertical,
          itemCount: matches.length,
          itemBuilder: (context, index) {
            return matches[index];
          },
        ),
      ),
    );
  }
}

class MatchupCard extends StatelessWidget {
  final Player firstPlayer;
  final Player secondPlayer;
  final TextStyle? bodyMediumWhite;

  const MatchupCard({
    super.key,
    required this.firstPlayer,
    required this.secondPlayer,
    required this.bodyMediumWhite,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.primary,
      child: Column(
        children: [
          PlayerCard(
            player: firstPlayer,
            bodyMediumWhite: bodyMediumWhite,
          ),
          // Spacer(),
          PlayerCard(
            player: secondPlayer,
            bodyMediumWhite: bodyMediumWhite,
          ),
        ],
      ),
    );
  }
}

class PlayerCard extends StatelessWidget {
  const PlayerCard({
    super.key,
    required this.player,
    required this.bodyMediumWhite,
  });

  final Player player;
  final TextStyle? bodyMediumWhite;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Row(
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 8),
          CircleAvatar(
              radius: 20, backgroundImage: AssetImage(player.avatarUrl)),
          SizedBox(width: 8),
          // SvgPicture.asset(
          //   width: 50,
          //   height: 50,
          //   avatar,
          //   semanticsLabel: 'Avatar from player',
          // ),
          Text(
            player.name,
            // style: bodyMediumWhite,
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
