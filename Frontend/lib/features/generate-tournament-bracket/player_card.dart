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

  String? playerId;
  final PlayerModel? player;
  final bool selectPlayer;
  final String avatarUrl = "assets/images/avatar_placeholder.png";
  // final List<String> tournamentPlayers = [
  //   "Michael van Gerwen",
  //   "Peter Wright",
  //   "Gerwyn Price",
  //   "Rob Cross",
  //   "Gary Anderson",
  //   "Nathan Aspinall",
  //   "Dimitri Van den Bergh",
  //   "James Wade",
  //   "Dave Chisnall",
  //   "Michael Smith",
  //   "José de Sousa",
  //   "Jonny Clayton",
  //   "Daryl Gurney",
  //   "Mensur Suljovic",
  //   "Devon Petersen",
  //   "Danny Noppert",
  // ];

  DropdownMenu<dynamic> makeDropdown(TournamentStore tournamentStore) {
    if (tournamentStore.unselectedPlayers.isEmpty) {
      if (tournamentStore.players.isNotEmpty) {
        tournamentStore.unselectedPlayers = tournamentStore.players;
      } else {
        tournamentStore.unselectedPlayers.add(PlayerModel.placeholderPlayer());
      }
    }

    List<DropdownMenuEntry<dynamic>> dropdownMenuEntries =
        tournamentStore.unselectedPlayers.map((unselectedPlayers) {
      return DropdownMenuEntry<dynamic>(
        value: unselectedPlayers.id.toString(), // Assuming roles are strings
        label: unselectedPlayers.fullName,
      );
    }).toList();

    DropdownMenu dropdownMenu = DropdownMenu(
      width: 230,
      // label: const Text('Name'),
      onSelected: (value) {
        playerId = value;
      },
      dropdownMenuEntries: dropdownMenuEntries,
    );

    return dropdownMenu;
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();
    Widget nameOfPlayer;

    if (tournamentStore.unselectedPlayers.isNotEmpty) {
      print("Je moeder");
    } else {
      print("niet zo je moder!");
    }

    if (selectPlayer) {
      nameOfPlayer = makeDropdown(tournamentStore);
    } else {
      nameOfPlayer = Text(
        player!.fullName,
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
          const SizedBox(width: 8),
          Expanded(
            child: nameOfPlayer,
          ),
          SizedBox(width: 4),
        ],
      ),
    );
  }
}
