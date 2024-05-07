// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
          child: SizedBox(
            width: 1200.00,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
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
                TournamentBrackets(
                  context: context,
                  players: players,
                ),
                SizedBox(height: 20),
                Container(
                  child: ElevatedButton(
                    child: Text("Create"),
                    onPressed: () => {},
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class Player {
  final String name;
  final String avatarUrl;

  Player(this.name, this.avatarUrl);
}

class TournamentBrackets extends StatelessWidget {
  const TournamentBrackets({
    super.key,
    required this.context,
    required this.players,
  });

  final BuildContext context;
  final List<Player> players;
  final String avatarUrl = "assets/images/avatar_placeholder.png";

  List<Widget> createRounds(List<Player> players, int round,
      {bool fillInPlayers = false}) {
    List<Widget> tournamentBracket = [];
    List<MatchupCard> matches =
        createMatches(players, fillInPlayers: fillInPlayers);

    final ScrollController _scrollController = ScrollController();

    Widget roundLayout = Column(
      children: [
        Text(
          "Round ${round.toString()}",
        ),
        Container(
          color: Colors.white,
          height: 500,
          width: 400,
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
        ),
      ],
    );

    tournamentBracket.add(roundLayout);

    if (matches.length > 1) {
      List<Player> nextRoundPlayers = [];
      for (var i = 1; i <= matches.length; i++) {
        nextRoundPlayers.add(Player("Winner match $i", avatarUrl));
      }

      List<Widget> nextRoundBracket =
          createRounds(nextRoundPlayers, ++round, fillInPlayers: true);
      tournamentBracket.addAll(nextRoundBracket);
    }

    return tournamentBracket;
  }

  List<MatchupCard> createMatches(List<Player> players,
      {bool fillInPlayers = false}) {
    List<MatchupCard> matches = [];
    Player placeholderPlayer = Player("", avatarUrl);
    var amountOfPlayers = players.length;
    var amountOfMatches = (amountOfPlayers / 2).ceil();

    while (amountOfMatches >= 1) {
      Player firstPlayer;
      Player secondPlayer;

      if (fillInPlayers) {
        firstPlayer =
            players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
        secondPlayer =
            players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
      } else {
        firstPlayer = placeholderPlayer;
        secondPlayer = placeholderPlayer;
      }

      matches.add(MatchupCard(
        firstPlayer: firstPlayer,
        secondPlayer: secondPlayer,
      ));

      amountOfMatches--;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> rounds = createRounds(players, 1, fillInPlayers: false);

    return Container(
      margin: EdgeInsets.only(bottom: 20.0),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: rounds,
        ),
      ),
    );
  }
}

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
    );
  }
}

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
          SizedBox(width: 8),
          CircleAvatar(
              radius: 20, backgroundImage: AssetImage(player.avatarUrl)),
          SizedBox(width: 8),
          Text(
            player.name,
          ),
          SizedBox(width: 8),
        ],
      ),
    );
  }
}
