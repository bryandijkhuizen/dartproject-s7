// ignore_for_file: prefer_const_constructors

import 'package:darts_application/features/generate-tournament-bracket/tournament_bracket_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'matchup_card.dart';

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
          height: 400,
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

      matches.add(
        MatchupCard(
          firstPlayer: firstPlayer,
          secondPlayer: secondPlayer,
        ),
      );

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
