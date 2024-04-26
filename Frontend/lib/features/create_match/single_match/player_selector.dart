import 'package:flutter/material.dart';

class PlayerSelector extends StatefulWidget {
  final Function(String, String) onSelectionChanged;

  const PlayerSelector({super.key, required this.onSelectionChanged});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector>{
  List<String> players = ['Luuk Ottens', 'Julian van Veen', 'Bryan Dijkhuizen', 'Kevin Herrema', 'Wietze Bronkema', 'Jelmer Bosma'];
  String? selectedOne;
  String? selectedTwo;

  void _handleTap(String playerId) {
  setState(() {
    if (selectedOne == null || selectedOne == playerId) {
      selectedOne = playerId;
    } else if (selectedTwo == null || selectedTwo == playerId) {
      selectedTwo = playerId;
    } else {
      selectedOne = selectedTwo;
      selectedTwo = playerId;
    }

    widget.onSelectionChanged(selectedOne ?? '', selectedTwo ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(players[index]),
          onTap: () => _handleTap(players[index]),
          selected: players[index] == selectedOne || players[index] == selectedTwo,
        );
      },
    );
  }
}