import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerSelector extends StatefulWidget {
  final Function(String, String) onSelectionChanged;

  const PlayerSelector({super.key, required this.onSelectionChanged});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector>{
  List<String> players = ['Luuk Ottens', 'Julian van Veen', 'Bryan Dijkhuizen', 'Kevin Herrema', 'Wietze Bronkema', 'Jelmer Bosma'];
  // List<String> players = ['test'];
  String? selectedOne;
  String? selectedTwo;

  // TODO: fetch current user_id
  String currentUser = "f27b1465-7969-465a-a237-a772be84a7a2";
  int? currentClub;

  Map<String, String> clubPlayerList = {};

  @override
  void initState() {
    super.initState();
    fetchClubMembers();
  }

  Future<void> fetchClubMembers() async {
    try {
      final userClub = await Supabase.instance.client
          .from('user_club')
          .select()
          .eq('user_id', currentUser)
          .single();

      final clubMembers = await Supabase.instance.client
          .from('user_club')
          .select()
          .eq('club_id', userClub['club_id']);

      Map<String, String> members = {};
      for (var user in clubMembers) {
        final memberName = await Supabase.instance.client
          .from('user')
          .select()
          .eq('id', user['user_id'])
          .single();

        members[user['id'].toString()] = "$memberName['first_name] $memberName['last_name]";
      }

    setState(() {
      currentClub = userClub['club_id'];
      clubPlayerList = members;
    });

    } catch (e) {
      throw Exception(('Failed to fetch users: $e'));
    }
  }

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
      // itemCount: clubPlayerList.length,
      itemCount: players.length,
      itemBuilder: (context, index) {
        return ListTile(
          title: Text(players[index]),
          onTap: () => _handleTap(players[index]),
          selected: players[index] == selectedOne || players[index] == selectedTwo,
        );
        // return Text('Current club: $currentClub');
      },
    );
  }
}