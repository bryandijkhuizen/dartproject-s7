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
      height: 200,
      width: 500,
      child: Scrollbar(
        controller: _scrollController,
        // child: Text(
        //     "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vestibulum a velit feugiat, rutrum erat ac, porttitor diam. Suspendisse aliquam urna eget fermentum mattis. Donec egestas luctus turpis ac dapibus. Sed id dapibus lorem, id venenatis elit. Etiam eget urna a tellus condimentum ultricies. Aliquam maximus interdum nibh, non maximus tellus sagittis id. Phasellus tincidunt, elit at auctor semper, elit purus imperdiet lectus, posuere pretium ipsum sapien ut dolor. Quisque nec lacinia augue. In eu tempus neque, vel cursus quam. Ut venenatis egestas arcu. Vestibulum tortor sem, consequat et arcu nec, semper euismod erat. Sed pulvinar placerat dolor, ut sollicitudin velit tristique sit amet. Mauris volutpat sagittis ligula, a luctus velit convallis sed. Nulla tincidunt tempus lorem sed venenatis. Fusce enim libero, consectetur vitae ex eget, bibendum egestas velit. Nam vehicula mi diam, et luctus odio scelerisque a. Proin egestas mi ut urna luctus, vel convallis urna luctus. Nam at justo luctus, consectetur nisl sodales, pharetra nunc. Donec in est sit amet magna congue vehicula sit amet ac libero. Curabitur id posuere augue, a finibus turpis. Nam quis nunc pharetra, venenatis sapien eu, tincidunt nibh. Mauris aliquet sapien diam. Suspendisse dapibus eget nibh et eleifend. Nunc non lacus felis. Morbi sollicitudin pretium enim, nec accumsan lacus placerat nec. Sed lobortis enim ipsum, sit amet rhoncus eros rhoncus ut. Phasellus at tristique est. Donec vel nulla eu nunc consequat pellentesque. In sagittis ligula nec massa commodo eleifend. Morbi id sagittis eros. Fusce interdum non nunc in tincidunt. Cras bibendum mollis diam. Vivamus vel arcu non lectus malesuada varius eu et ligula. Sed orci quam, pellentesque eu auctor eget, molestie quis risus. Fusce pretium arcu vitae libero feugiat cursus. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Morbi suscipit laoreet sollicitudin. Nullam semper ipsum in erat mattis, ut dictum mi ultricies. Etiam non mauris elit. In blandit, lectus id sodales ultricies, augue magna imperdiet arcu, in molestie diam ante ac mauris. Etiam congue arcu nisi, sit amet eleifend lorem posuere at."),
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
  final TextStyle? bodyMediumWhite;

  @override
  Widget build(BuildContext context) {
    return Text(
      playerName,
      style: bodyMediumWhite,
    );
  }
}
