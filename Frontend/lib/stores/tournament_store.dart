import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';

part 'tournament_store.g.dart';

class TournamentStore = _TournamentStore with _$TournamentStore;

abstract class _TournamentStore with Store {
  final SupabaseClient _supabase;
  @observable
  // bool initialized = false;
  List<MatchModel> matches = [];
  List<PlayerModel> players = [];
  @observable
  List<PlayerModel> unselectedPlayers;
  List<PlayerModel> selectedPlayers = [];

  _TournamentStore(
    this._supabase, {
    List<PlayerModel>? unselectedPlayers,
  }) : unselectedPlayers = unselectedPlayers ?? [];

  Future<Map<String, dynamic>> getPlayerById(String id) async {
    Map<String, dynamic> response =
        await _supabase.from('user').select('*').eq('id', id).single();

    return response;
  }

  Future<List<PlayerModel>> getPlayersByIds(List<String> playerIds) async {
    final response = await _supabase
        .rpc("get_users_by_uuids", params: {"uuid_list": playerIds});

    if (response.isEmpty) {
      throw Exception(
          'Error fetching data: ${response.length} amount of user\'s found');
    }

    final List<dynamic> userData = response;

    List<PlayerModel> playerModels = userData.map((userMap) {
      return PlayerModel.fromJson(userMap);
    }).toList();

    // initialized = true;

    return playerModels;
  }

  MatchModel addMatch(
    PlayerModel firstPlayer,
    PlayerModel secondPlayer,
    DateTime date,
    int setTarget,
    int legTarget,
  ) {
    int matchId = matches.length + 1;
    final MatchModel newMatch = MatchModel(
      id: matchId.toString(),
      player1Id: firstPlayer.id,
      player2Id: secondPlayer.id,
      date: date,
      setTarget: setTarget,
      legTarget: legTarget,
      startingScore: 0,
      player1LastName: firstPlayer.lastName,
      player2LastName: secondPlayer.lastName,
    );

    matches.add(newMatch);
    return newMatch;
  }

  PlayerModel getPlayerFromPlayers(String playerId) {
    if (playerId == "") throw Exception("Unselected player has no ID");
    if (players.isEmpty) throw Exception("There are no players in Tournament");

    // Get current player
    PlayerModel? player =
        players.firstWhereOrNull((player) => player.id == playerId);

    if (player == null) throw Exception("Player with id: $playerId Not found.");

    return player;
  }

  void unselectPlayer(
    String playerId,
    String matchId,
    bool isFirstPlayer,
  ) {
    PlayerModel player = getPlayerFromPlayers(playerId);

    // Add player to unselectedPlayers
    unselectedPlayers.add(player);

    // Remove from selectedPlayers
    selectedPlayers.removeWhere(
      (selectedPlayer) => selectedPlayer.id == player.id,
    );

    // Remove from corresponding match in tournament store
    final matchIndex = matches.indexWhere((match) => match.id == matchId);

    if (matchIndex != -1) {
      final updatedMatch = matches[matchIndex];

      if (isFirstPlayer) {
        updatedMatch.player1Id = "";
        updatedMatch.player1LastName = "";
      } else {
        updatedMatch.player2Id = "";
        updatedMatch.player2LastName = "";
      }

      print('Match with ID $matchId updated successfully.');
    } else {
      print("Match with ID $matchId not found.");
    }
  }

  void selectPlayer(
    String playerId,
    String matchId,
    bool isFirstPlayer,
  ) {
    PlayerModel player = getPlayerFromPlayers(playerId);
    // Remove player from unselectedPlayers
    unselectedPlayers.removeWhere(
      (unselectedPlayer) => unselectedPlayer.id == player.id,
    );

    // Add player to selectedPlayers
    selectedPlayers.add(player);

    // Add player to corresponding match in tournament store
    final matchIndex = matches.indexWhere((match) => match.id == matchId);

    if (matchIndex != -1) {
      final updatedMatch = matches[matchIndex];

      if (isFirstPlayer) {
        updatedMatch.player1Id = player.id;
        updatedMatch.player1LastName = player.lastName;
      } else {
        updatedMatch.player2Id = player.id;
        updatedMatch.player2LastName = player.lastName;
      }

      print('Match with ID $matchId updated successfully.');
    } else {
      print("Match with ID $matchId not found.");
    }
  }

  // @action
  // selectPlayer(String playerName, int matchNumber) {
  //   unselectedPlayers.remove(playerName);
  //   selectedPlayers.add(playerName);
  // }

  // @computed
  // String get firstPlayer => unselectedPlayers.first;
}
