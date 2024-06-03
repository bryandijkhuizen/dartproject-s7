import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class PlayerCard extends StatefulWidget {
  const PlayerCard({
    super.key,
    required this.canSelectPlayer,
    required this.roundNumber,
    required this.matchIndex,
    PlayerModel? player,
    required this.isFirstPlayer,
  }) : _player = player;

  final bool canSelectPlayer;
  final int roundNumber;
  final int matchIndex;
  final PlayerModel? _player;
  final bool isFirstPlayer;

  @override
  State<PlayerCard> createState() => _PlayerCardState();
}

class _PlayerCardState extends State<PlayerCard>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;
  List<DropdownMenuEntry<dynamic>> dropdownMenuEntries = [];
  PlayerModel? player;

  final String avatarUrl = "assets/images/avatar_placeholder.png";

  @override
  void initState() {
    super.initState();
    player = widget._player;
  }

  void unselectPlayer() {
    if (this.player == null) return;

    TournamentStore store = context.read<TournamentStore>();
    PlayerModel player = this.player!;

    // Remove from player_card
    setState(() {
      this.player = null;
    });

    // Remove player from matchup_card and tournament store
    store.unselectPlayer(
      player,
      widget.roundNumber,
      widget.matchIndex,
      widget.isFirstPlayer,
    );
  }

  void selectPlayer(String playerId) {
    TournamentStore store = context.read<TournamentStore>();
    PlayerModel player = store.getPlayerFromPlayers(playerId);

    // Add player to player_card
    setState(() {
      this.player = player;
    });

    // Add player to tournament store
    store.selectPlayer(
      player,
      widget.roundNumber,
      widget.matchIndex,
      widget.isFirstPlayer,
    );
  }

  void updateDropdownMenuEntries(BuildContext context) {
    TournamentStore store = context.read<TournamentStore>();

    dropdownMenuEntries = store.unselectedPlayers.map((unselectedPlayer) {
      return DropdownMenuEntry<dynamic>(
        value: unselectedPlayer.id.toString(),
        label: unselectedPlayer.fullName,
      );
    }).toList();
  }

  Observer makeDropdown(BuildContext context) {
    TournamentStore store = context.read<TournamentStore>();

    // Check if unselectedPlayers is not empty
    if (store.unselectedPlayers.isEmpty) {
      if (store.players.isNotEmpty) {
        store.unselectedPlayers = List.from(store.players);
      } else {
        store.unselectedPlayers.add(PlayerModel.placeholderPlayer());
      }
    }

    updateDropdownMenuEntries(context);

    return Observer(builder: (context) {
      print(store.unselectedPlayers.length);
      return DropdownMenu(
        width: 230,
        dropdownMenuEntries: dropdownMenuEntries,
        onSelected: (value) {
          setState(() {
            if (player != null) {
              unselectPlayer();
            }
            selectPlayer(value);
          });
        },
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
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
          // CircleAvatar(
          //   radius: 20,
          //   backgroundImage: AssetImage(
          //       // Get avatar from database
          //       player!.avatarId != "" ? "${player!.avatarId}" : avatarUrl,
          //       ),
          // ),
          const SizedBox(width: 8),
          Expanded(
            child: nameOfPlayer,
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  }
}
