import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/models/club.dart';
import 'package:darts_application/models/club_member.dart';
import 'package:darts_application/components/search_input.dart';

class PlayerSelector extends StatefulWidget {
  final Function(List<PlayerModel>) onSelectionChanged;

  const PlayerSelector({super.key, required this.onSelectionChanged});

  @override
  State<PlayerSelector> createState() => _PlayerSelectorState();
}

class _PlayerSelectorState extends State<PlayerSelector> {
  List<PlayerModel> selectedPlayers = [];
  List<PlayerModel> players = [];
  List<PlayerModel> filteredPlayers = [];
  List<Club> clubs = [];
  List<ClubMember> clubMembers = [];
  Map<String, List<Club>> playerClubsMap = {};

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchMembersAndClubs();
  }

  Future<void> fetchMembersAndClubs() async {
    try {
      // Fetch players
      final playerResponse =
          await Supabase.instance.client.from('user').select();
      final List<dynamic> playerData = playerResponse as List<dynamic>;
      List<PlayerModel> fetchedPlayers = playerData.map((row) {
        return PlayerModel.fromJson(row);
      }).toList();

      // Fetch clubs
      final clubResponse = await Supabase.instance.client.from('club').select();
      final List<dynamic> clubData = clubResponse as List<dynamic>;
      List<Club> fetchedClubs = clubData.map((row) {
        return Club.fromJson(row);
      }).toList();

      // Fetch club members
      final clubMemberResponse =
          await Supabase.instance.client.from('user_club').select();
      final List<dynamic> clubMemberData = clubMemberResponse as List<dynamic>;
      List<ClubMember> fetchedClubMembers = clubMemberData.map((row) {
        return ClubMember.fromJson(row);
      }).toList();

      // Create map of player IDs to their associated clubs
      Map<String, List<Club>> tempPlayerClubsMap = {};
      for (var clubMember in fetchedClubMembers) {
        if (!tempPlayerClubsMap.containsKey(clubMember.userId)) {
          tempPlayerClubsMap[clubMember.userId] = [];
        }
        var club = fetchedClubs.firstWhere((c) => c.id == clubMember.clubId);
        tempPlayerClubsMap[clubMember.userId]!.add(club);
      }

      setState(() {
        players = fetchedPlayers;
        filteredPlayers = fetchedPlayers;
        clubs = fetchedClubs;
        clubMembers = fetchedClubMembers;
        playerClubsMap = tempPlayerClubsMap;
      });
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  void searchClubs() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredPlayers = players;
      });
      return;
    }

    List<PlayerModel> tempFilteredPlayers = players.where((player) {
      List<Club> playerClubs = playerClubsMap[player.id] ?? [];
      return playerClubs.any((club) => club.name.toLowerCase().contains(query));
    }).toList();

    setState(() {
      filteredPlayers = tempFilteredPlayers;
    });
  }

  void togglePlayerSelection(PlayerModel player) {
    setState(() {
      if (selectedPlayers.contains(player)) {
        selectedPlayers.remove(player);
      } else {
        selectedPlayers.add(player);
      }
      widget.onSelectionChanged(selectedPlayers);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 300,
          height: 50,
          child: SearchInput(
            controller: searchController,
            onSearch: searchClubs,
          ),
        ),
        SizedBox(
          height: 200,
          child: Column(
            children: [
              Expanded(
                child: filteredPlayers.isEmpty
                    ? const Center(child: CircularProgressIndicator())
                    : ListView.builder(
                        itemCount: filteredPlayers.length,
                        itemBuilder: (context, index) {
                          PlayerModel player = filteredPlayers[index];
                          bool isSelected = selectedPlayers.contains(player);
                          List<Club> playerClubs =
                              playerClubsMap[player.id] ?? [];
                          String clubs =
                              playerClubs.map((club) => club.name).join(', ');
                          return ListTile(
                            title:
                                Text("${player.firstName} ${player.lastName}"),
                            subtitle: Text(clubs.isEmpty ? 'No clubs' : clubs),
                            trailing: isSelected
                                ? const Icon(Icons.check_box,
                                    color: Colors.green)
                                : const Icon(Icons.check_box_outline_blank),
                            onTap: () => togglePlayerSelection(player),
                          );
                        },
                      ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
