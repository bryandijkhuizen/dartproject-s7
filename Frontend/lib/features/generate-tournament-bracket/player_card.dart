import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PlayerCard extends StatefulWidget {
  const PlayerCard({
    super.key,
    required this.canSelectPlayer,
    required this.selectPlayerFunction,
    required this.unselectPlayerFunction,
    PlayerModel? player,
    required this.isFirstPlayer,
  }) : _player = player;

  final bool canSelectPlayer;
  final Function selectPlayerFunction;
  final Function unselectPlayerFunction;
  final PlayerModel? _player;
  final bool isFirstPlayer;

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard> {
  String? playerId;
  PlayerModel? player;

  final String avatarUrl = "assets/images/avatar_placeholder.png";

  @override
  void initState() {
    super.initState();
    player = widget._player; // Assign the value to player
  }

  void unselectPlayer(TournamentStore tournamentStore) {
    if (this.player == null) return;

    PlayerModel player = this.player!;

    // Remove from player_card
    setState(() {
      this.player = null;
    });

    // Remove player from matchup_card and tournament store
    widget.unselectPlayerFunction(
        tournamentStore, widget.isFirstPlayer, player);
  }

  void selectPlayer(TournamentStore tournamentStore, String playerId) {
    PlayerModel player = tournamentStore.getPlayerFromPlayers(playerId);

    // Add player to player_card
    setState(() {
      this.player = player;
    });

    // Add player to matchup_card and tournament store
    widget.selectPlayerFunction(tournamentStore, widget.isFirstPlayer, player);
  }

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
        if (player != null) {
          unselectPlayer(tournamentStore);
        }
        selectPlayer(tournamentStore, value);
      },
      dropdownMenuEntries: dropdownMenuEntries,
    );

    return dropdownMenu;
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();
    Widget nameOfPlayer;

    if (widget.canSelectPlayer) {
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
