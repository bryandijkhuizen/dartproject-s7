import 'package:darts_application/models/player.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/club_member.dart';

class PlayerSelector extends StatefulWidget {
  final Function(String, String, String, String) onSelectionChanged;
  final bool isFriendly;

  const PlayerSelector(
      {super.key, required this.onSelectionChanged, required this.isFriendly});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  String? selectedOne;
  String? selectedTwo;

  int? currentClub;
  String? clubName;

  List<PlayerModel> allPlayers = [];
  List<ClubMember> clubMembers = [];
  List<dynamic> filteredPlayers = [];
  List<dynamic> filteredMembers = [];

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPlayers();
    searchController.addListener(_filterList);
  }

  @override
  void didUpdateWidget(covariant PlayerSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isFriendly != oldWidget.isFriendly) {
      fetchPlayers();
    }
  }

  Future<void> fetchPlayers() async {
    try {
      final userId = Supabase.instance.client.auth.currentUser!.id;

      if (widget.isFriendly) {
        final response = await Supabase.instance.client.from('user').select();
        final data = response as List<dynamic>;

        List<PlayerModel> players = data.map((row) {
          return PlayerModel.fromJson(row);
        }).toList();

        setState(() {
          allPlayers = players;
          filteredPlayers = players;
        });
      } else {
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
          } else {
            clubName = null;
          }
          clubMembers = members;
          filteredMembers = members;
        });
      }
    } catch (e) {
      print('Error fetching players: $e');
    }
  }

  void _filterList() {
    String query = searchController.text.toLowerCase();
    setState(() {
      if (widget.isFriendly) {
        filteredPlayers = allPlayers.where((player) {
          return player.lastName.toLowerCase().contains(query);
        }).toList();
      } else {
        filteredMembers = clubMembers.where((member) {
          return member.lastName.toLowerCase().contains(query);
        }).toList();
      }
    });
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

      if (widget.isFriendly) {
        final selectedOnePlayer = allPlayers.firstWhere(
            (player) => player.id == selectedOne,
            orElse: () =>
                PlayerModel(id: '', firstName: '', lastName: '', avatarId: ''));
        final selectedTwoPlayer = allPlayers.firstWhere(
            (player) => player.id == selectedTwo,
            orElse: () =>
                PlayerModel(id: '', firstName: '', lastName: '', avatarId: ''));

        widget.onSelectionChanged(selectedOne ?? '', selectedTwo ?? '',
            selectedOnePlayer.lastName, selectedTwoPlayer.lastName);
      } else {
        final selectedOneMember = clubMembers.firstWhere(
            (member) => member.userId == selectedOne,
            orElse: () =>
                ClubMember(userId: '', lastName: '', clubId: 0, clubName: ''));
        final selectedTwoMember = clubMembers.firstWhere(
            (member) => member.userId == selectedTwo,
            orElse: () =>
                ClubMember(userId: '', lastName: '', clubId: 0, clubName: ''));

        widget.onSelectionChanged(selectedOne ?? '', selectedTwo ?? '',
            selectedOneMember.lastName, selectedTwoMember.lastName);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: searchController,
          decoration: const InputDecoration(
            labelText: 'Search',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        if (!widget.isFriendly && clubName != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Showing members of club $clubName:',
            ),
          ),
        Flexible(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.isFriendly
                ? filteredPlayers.length
                : filteredMembers.length,
            itemBuilder: (context, index) {
              if (widget.isFriendly) {
                final player = filteredPlayers[index] as PlayerModel;
                return ListTile(
                  title: Text(player.lastName),
                  onTap: () => updateSelected(player.id),
                  selected:
                      player.id == selectedOne || player.id == selectedTwo,
                );
              } else {
                final member = filteredMembers[index] as ClubMember;
                return ListTile(
                  title: Text(member.lastName),
                  onTap: () => updateSelected(member.userId),
                  selected: member.userId == selectedOne ||
                      member.userId == selectedTwo,
                );
              }
            },
          ),
        ),
      ],
    );
  }
}
