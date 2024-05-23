import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'matchup_card.dart';

class TournamentBrackets extends StatelessWidget {
  TournamentBrackets({
    super.key,
    required this.context,
  });

  // final String avatarUrl = "assets/images/avatar_placeholder.png";
  final BuildContext context;

  List<Widget> createRounds(
    TournamentStore tournamentStore,
    List<PlayerModel> players,
    int round, {
    bool selectPlayer = false,
    bool fillInPlayers = false,
  }) {
    List<Widget> tournamentBracket = [];
    List<MatchupCard> matches = createMatches(
      tournamentStore,
      players,
      selectPlayer: selectPlayer,
      fillInPlayers: fillInPlayers,
    );

    final ScrollController _scrollController = ScrollController();

    Widget roundLayout = Row(
      children: [
        const SizedBox(width: 4),
        Column(
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
        ),
        const SizedBox(width: 4),
      ],
    );

    tournamentBracket.add(roundLayout);

    if (matches.length > 1) {
      List<PlayerModel> nextRoundPlayers = [];
      for (var i = 1; i <= matches.length; i++) {
        nextRoundPlayers
            .add(PlayerModel.placeholderPlayer(firstName: "Winner match $i"));
      }

      List<Widget> nextRoundBracket = createRounds(
        tournamentStore,
        nextRoundPlayers,
        ++round,
        selectPlayer: false,
        fillInPlayers: true,
      );
      tournamentBracket.addAll(nextRoundBracket);
    }

    return tournamentBracket;
  }

  List<MatchupCard> createMatches(
    TournamentStore tournamentStore,
    List<PlayerModel> players, {
    bool selectPlayer = false,
    bool fillInPlayers = false,
  }) {
    PlayerModel placeholderPlayer = PlayerModel.placeholderPlayer();
    List<MatchupCard> matches = [];
    var amountOfPlayers = players.length;
    var amountOfMatches = (amountOfPlayers / 2).ceil();

    if (amountOfPlayers < 1 || amountOfMatches < 1) {
      throw Exception("Not enough players where found to create a match");
    }

    while (amountOfMatches >= 1) {
      PlayerModel firstPlayer;
      PlayerModel secondPlayer;

      if (fillInPlayers) {
        firstPlayer =
            players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
        secondPlayer =
            players.isNotEmpty ? players.removeAt(0) : placeholderPlayer;
      } else {
        firstPlayer = placeholderPlayer;
        secondPlayer = placeholderPlayer;
      }

      MatchModel newMatch = tournamentStore.addMatch(
        firstPlayer,
        secondPlayer,
        DateTime.now().add(const Duration(days: 1)),
        501, // Get this information from tournament settings page
        5,
      );

      matches.add(
        MatchupCard(
          match: newMatch,
          selectPlayer: selectPlayer,
        ),
      );

      amountOfMatches--;
    }

    return matches;
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();

    List<Widget> rounds = createRounds(
      tournamentStore,
      tournamentStore.players,
      1,
      selectPlayer: true,
      fillInPlayers: false,
    );

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
