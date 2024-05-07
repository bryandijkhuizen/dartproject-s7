import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PlayerSelector extends StatefulWidget {
  final Function(String, String) onSelectionChanged;

  const PlayerSelector({super.key, required this.onSelectionChanged});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector>{
  String? selectedOne;
  String? selectedTwo;

  int? currentClub;
  String? clubName;

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
          .eq('user_id', Supabase.instance.client.auth.currentUser!.id)
          .single();

      final clubInfo = await Supabase.instance.client.from('club').select().eq('id', userClub['club_id']).single(); 

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
        
        members[user['user_id'].toString()] = memberName['first_name'] + " " + memberName['last_name'];
      }

    setState(() {
      currentClub = userClub['club_id'];
      clubName = clubInfo['name'];
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'Showing members of club $clubName:',
          ),
        ),
        ListView(
          shrinkWrap: true,
          children: clubPlayerList.entries.map((entry) {
            return ListTile(
              title: Text(entry.value),
              onTap: () => _handleTap(entry.key),
              selected: entry.key == selectedOne || entry.key == selectedTwo,
            );
          }).toList(),
        ),
      ],
    );
  }}