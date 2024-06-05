import 'dart:convert';

import 'package:darts_application/features/clubs/stores/club_registration_view_store.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:collection/collection.dart';

part 'tournament_store.g.dart';

class TournamentStore = _TournamentStore with _$TournamentStore;

abstract class _TournamentStore with Store {
  final SupabaseClient _supabase;
  int setTarget = 3;
  int legTarget = 5;
  int startingScore = 501;
  @observable
  bool initialized = false;

  List<PlayerModel> players;
  late Map<int, List<MatchModel>> rounds;
  @observable
  List<PlayerModel> unselectedPlayers;

  _TournamentStore(this._supabase, this.players)
      : unselectedPlayers = players.toList() {
    _setup();
  }

  Future<void> _setup() async {
    await setTournamentPlayers(); //Set Players for testing
    rounds = createRounds(
      players,
      1,
      fillInPlayers: false,
    );

    initialized = true;
  }

  Future<void> setTournamentPlayers() async {
    // For now use test data
    final List<String> playerIds = [
      "0ae2876c-fd04-42d8-9628-fdc0114bd266",
      "9147fbea-4ae7-4942-a22c-26bf837d7d91",
      "ac2aab4b-0782-43cd-bb1c-1ecd2634782e",
      "522ee4ba-2aab-4b79-8a28-5993f3d675cb",
      "21daf6df-ac80-439e-bf52-ff00bf45aa0e",
      "9b84e770-f578-4d8a-9abb-bd350acb0cb5",
      "0e7616b4-ef22-40cf-816a-28b43c064f24",
      "848b4a42-c5b0-400d-9e64-786e831ef7f4",
      "12a04654-a72c-4faf-9c9a-70d8bdebb935",
      "0a31e269-b3b7-41c9-85e2-a7f072f565a2",
      "686b091a-ba3b-467e-b7b3-62145a55afbf",
      "d4324948-a902-4c83-af3b-6cdfbf8c4d84",
      "17ced10b-4b21-46d6-867b-f9b438d8a09c",
      "a66186b5-4f5e-41ec-9d85-870aa6ac800b",
      "5b7cc84d-82ac-45fb-89fc-2eb977105526",
      "47c9de89-be90-457c-aede-b1496b3e37ca"
    ];

    players = await getPlayersByIds(playerIds);

    players = players;
    unselectedPlayers = List.from(players);
  }

  Future<Map<String, dynamic>> getPlayerById(String id) async {
    Map<String, dynamic> response =
        await _supabase.from('user').select('*').eq('id', id).single();

    return response;
  }

  Future<List<PlayerModel>> getPlayersByIds(List<String> playerIds) async {
    // ToDo add try catch
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

  Map<int, List<MatchModel>> createRounds(
    List<PlayerModel> players,
    int round, {
    bool fillInPlayers = false,
  }) {
    Map<int, List<MatchModel>> rounds = {};

    List<MatchModel> matches = addMatches(
      players,
      fillInPlayers: fillInPlayers,
    );

    rounds = {round: matches};

    if (matches.length > 1) {
      List<PlayerModel> nextRoundPlayers = [];
      for (var i = 1; i <= matches.length; i++) {
        nextRoundPlayers
            .add(PlayerModel.placeholderPlayer(lastName: "Winner match $i"));
      }

      Map<int, List<MatchModel>> nextRounds = createRounds(
        nextRoundPlayers,
        ++round,
        fillInPlayers: true,
      );

      rounds.addAll(nextRounds);
    }

    return rounds;
  }

  List<MatchModel> addMatches(
    List<PlayerModel> players, {
    bool fillInPlayers = false,
  }) {
    List<MatchModel> matches = [];
    int amountOfPlayers = players.length;
    int amountOfMatches = (amountOfPlayers / 2).ceil();

    while (amountOfMatches >= 1) {
      PlayerModel firstPlayer;
      PlayerModel secondPlayer;

      if (fillInPlayers) {
        firstPlayer = players.isNotEmpty
            ? players.removeAt(0)
            : PlayerModel.placeholderPlayer();
        secondPlayer = players.isNotEmpty
            ? players.removeAt(0)
            : PlayerModel.placeholderPlayer();
      } else {
        firstPlayer = PlayerModel.placeholderPlayer();
        secondPlayer = PlayerModel.placeholderPlayer();
      }

      MatchModel newMatch = addMatch(
        firstPlayer,
        secondPlayer,
        DateTime.now().add(const Duration(days: 1)),
        setTarget, // Get this information from tournament settings page
        legTarget,
      );

      matches.add(newMatch);

      amountOfMatches--;
    }

    return matches;
  }

  MatchModel addMatch(
    PlayerModel firstPlayer,
    PlayerModel secondPlayer,
    DateTime date,
    int setTarget,
    int legTarget, {
    String id = "",
  }) {
    // String matchId = "";
    final MatchModel newMatch = MatchModel(
      id: id,
      player1Id: firstPlayer.id,
      player2Id: secondPlayer.id,
      date: date,
      setTarget: setTarget,
      legTarget: legTarget,
      startingScore: startingScore,
      player1LastName: firstPlayer.lastName,
      player2LastName: secondPlayer.lastName,
    );

    return newMatch;
  }

  PlayerModel getPlayerFromPlayers(String playerId) {
    if (playerId == "") throw Exception("No playerId is given.");
    if (players.isEmpty) throw Exception("There are no players in Tournament");

    // Get current player
    // ToDo Make it so that it does not pull the player out of the list
    PlayerModel? player =
        players.firstWhereOrNull((player) => player.id == playerId);

    if (player == null) throw Exception("Player with id: $playerId Not found.");

    return player;
  }

  void unselectPlayer(
    PlayerModel player,
    int roundNumber,
    int matchIndex,
    bool isFirstPlayer,
  ) {
    try {
      MatchModel match = rounds[roundNumber]![matchIndex];
      player = getPlayerFromPlayers(player.id);

      if (isFirstPlayer) {
        match.player1Id = "";
        match.player1LastName = "";
      } else {
        match.player2Id = "";
        match.player2LastName = "";
      }

      // Add player to unselectedPlayers
      unselectedPlayers.add(player);

      print('Match with ID ${match.id} updated successfully.');
    } catch (error) {
      if (error is RangeError) {
        print(
            'Error: Index out of bounds. Please check the range of matchIndex.');
      } else if (error is NoSuchMethodError) {
        print('Error: The item at matchIndex is null or not found.');
      } else {
        print('There was an error: $error');
      }
    }
  }

  void selectPlayer(
    PlayerModel player,
    int roundNumber,
    int matchIndex,
    bool isFirstPlayer,
  ) {
    // Update match with selected player
    try {
      MatchModel match = rounds[roundNumber]![matchIndex];

      if (isFirstPlayer) {
        match.player1Id = player.id;
        match.player1LastName = player.lastName;
      } else {
        match.player2Id = player.id;
        match.player2LastName = player.lastName;
      }
      print('Match with ID ${match.id} updated successfully.');
    } catch (error) {
      if (error is RangeError) {
        print(
            'Error: Index out of bounds. Please check the range of matchIndex.');
      } else if (error is NoSuchMethodError) {
        print('Error: The item at matchIndex is null or not found.');
      } else {
        print('There was an error: $error');
      }
    }

    // Remove player from unselectedPlayers
    unselectedPlayers.removeWhere(
      (unselectedPlayer) => unselectedPlayer.id == player.id,
    );
  }

  Future<SupabaseResultType> createTournament() async {
    SupabaseResultType resultType;
    //TODO when intergrations is build this should be set to the tournament ID given bij wietses page
    int tournament_id = 2;
    try {
      rounds.forEach(
        (roundNumber, matches) async {
          var json = jsonEncode(matches);
          Map<String, dynamic> resultJson = await _supabase
              .rpc<Map<String, dynamic>>('create_tournament_round',
                  params: {"match_data": matches, 'current_tournament_id' : tournament_id, 'current_round_number' : roundNumber });

          SupabaseResultType result =  SupabaseResultType.fromJson(resultJson);
          if(!result.success){
            throw SupabaseException(result.message);
          } 
        },
      );
    } on SupabaseException catch (e) {
      return SupabaseResultType(
        success: false,
        message: e.cause,
      );
    }
    catch (e) {
      return const SupabaseResultType(
        success: false,
        message: 'Unknown error occurred.',
      );
    }
    return const SupabaseResultType(success: true, message: 'Succesfully created tournament');

  }

}

class SupabaseException implements Exception {
  String cause;
  SupabaseException(this.cause);
}
