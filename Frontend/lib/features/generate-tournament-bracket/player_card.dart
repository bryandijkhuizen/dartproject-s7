import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
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
  List<DropdownMenuEntry<dynamic>> dropdownMenuEntries = [];
  String? playerId;
  PlayerModel? player;

  final String avatarUrl = "assets/images/avatar_placeholder.png";

  @override
  void initState() {
    super.initState();
    player = widget._player;
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

  void updateDropdownMenuEntries(TournamentStore tournamentStore) {
    dropdownMenuEntries =
        tournamentStore.unselectedPlayers.map((unselectedPlayer) {
      return DropdownMenuEntry<dynamic>(
        value: unselectedPlayer.id.toString(),
        label: unselectedPlayer.fullName,
      );
    }).toList();
  }

  Observer makeDropdown(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();

    if (tournamentStore.unselectedPlayers.isEmpty) {
      if (tournamentStore.players.isNotEmpty) {
        tournamentStore.unselectedPlayers = tournamentStore.players;
      } else {
        tournamentStore.unselectedPlayers.add(PlayerModel.placeholderPlayer());
      }
    }

    updateDropdownMenuEntries(tournamentStore);
    return Observer(builder: (context) {
      return DropdownMenu(
        width: 230,
        // label: const Text('Name'),
        dropdownMenuEntries: dropdownMenuEntries,
        onSelected: (value) {
          setState(() {
            playerId = value;
            if (player != null) {
              unselectPlayer(tournamentStore);
            }
            selectPlayer(tournamentStore, value);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    TournamentStore tournamentStore = context.read<TournamentStore>();
    Widget nameOfPlayer;

    if (widget.canSelectPlayer) {
      nameOfPlayer = makeDropdown(context);
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
              // Get avatar from database
              player!.avatarId != "" ? "${player!.avatarId}" : avatarUrl,
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
