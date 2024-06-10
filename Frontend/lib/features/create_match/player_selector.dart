import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/club_member.dart';

class PlayerSelector extends StatefulWidget {
  final Function(String, String, String, String) onSelectionChanged;

  const PlayerSelector({super.key, required this.onSelectionChanged});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  String? selectedOne;
  String? selectedTwo;

  int? currentClub;
  String? clubName;

  List<ClubMember> clubMembers = [];

  @override
  void initState() {
    super.initState();
    fetchClubMembers();
  }

  Future<void> fetchClubMembers() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      final response = await Supabase.instance.client
          .rpc('get_club_members', params: {'p_user_id': userId});

      final data = response as List<dynamic>;

      List<ClubMember> members = data.map((row) {
        return ClubMember.fromJson(row);
      }).toList();

      setState(() {
        if (members.isNotEmpty) {
          currentClub = members[0].clubId;
          clubName = members[0].clubName;
        }
        clubMembers = members;
      });
    } catch (e) {
      print('Error fetching club members: $e');
    }
  }

  void updateSelected(String playerId) {
    setState(() {
      if (selectedOne == null || selectedOne == playerId) {
        selectedOne = playerId;
      } else if (selectedTwo == null || selectedTwo == playerId) {
        selectedTwo = playerId;
      } else {
        selectedOne = selectedTwo;
        selectedTwo = playerId;
      }

      final selectedOneMember = clubMembers.firstWhere((member) => member.userId == selectedOne, orElse: () => ClubMember(userId: '', lastName: '', clubId: 0, clubName: ''));
      final selectedTwoMember = clubMembers.firstWhere((member) => member.userId == selectedTwo, orElse: () => ClubMember(userId: '', lastName: '', clubId: 0, clubName: ''));

      widget.onSelectionChanged(
        selectedOne ?? '',
        selectedTwo ?? '',
        selectedOneMember.lastName,
        selectedTwoMember.lastName
      );
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
          children: clubMembers.map((member) {
            return ListTile(
              title: Text(member.lastName),
              onTap: () => updateSelected(member.userId),
              selected: member.userId == selectedOne || member.userId == selectedTwo,
            );
          }).toList(),
        ),
      ],
    );
  }
}
