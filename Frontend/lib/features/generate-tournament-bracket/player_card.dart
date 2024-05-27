import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerCard extends StatelessWidget {
  PlayerCard({
    super.key,
    required this.player,
    required this.selectPlayer,
  });

  final PlayerModel? player;
  final bool selectPlayer;
  final String avatarUrl = "assets/images/avatar_placeholder.png";
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
    TournamentStore tournamentStore = context.read<TournamentStore>();
    String playerId;
    Widget nameOfPlayer;

    List<DropdownMenuEntry<dynamic>> dropdownMenuEntries =
        tournamentPlayers.map((tournamentPlayer) {
      return DropdownMenuEntry<dynamic>(
        value: tournamentPlayer.toString(), // Assuming roles are strings
        label: tournamentPlayer.toString(),
      );
    }).toList();

    if (selectPlayer) {
      nameOfPlayer = DropdownMenu(
        width: 230,
        // label: const Text('Name'),
        onSelected: (value) {
          playerId = value;
        },
        dropdownMenuEntries: dropdownMenuEntries,
      );
    } else {
      nameOfPlayer = Text(
        player!.lastName,
      );
    }

    return Card(
      child: Row(
        children: [
          const SizedBox(
            width: 4,
            height: 60,
          ),
          CircleAvatar(
            radius: 20,
            backgroundImage: AssetImage(
              player!.avatarId != "1" ? player!.avatarId : avatarUrl,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: nameOfPlayer,
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
