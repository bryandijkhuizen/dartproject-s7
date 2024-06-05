import 'dart:convert';

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
      "f66f7d7b-9375-4169-86d3-f33d0c90404a",
      "57161ed6-9d97-440f-96e8-a23640465bc7",
      "65e7049d-d54a-420f-887e-547e21f53c46",
      "70cb4e90-c241-44f0-9cd6-7b4366f5bf8b",
      "e1345329-7f8f-4eb5-ac91-c2874fb47ef4",
      "17b6d72a-ef9a-4dc2-8556-74f6b009da32",
      "be427ad1-055b-450c-83dd-e76e428fe261",
      "47f51364-e7b7-4340-8972-52326c371a16",
      "3ba4c167-db09-4ec2-9d00-48cd666b43e0",
      "b1ba72e3-e8ee-491a-b9dc-90193efa4b67",
      "a64aab42-8e0b-41b6-8144-68863211283b",
      "c1fa1326-3443-43c8-83c5-6807279746e7",
      "bb91e207-1745-437a-af0d-d7ce17cad353",
      "854b4e24-9b2a-4ee1-bff7-4a219099153d",
      "dfc7bbc5-2e03-49d1-90a2-717e18fd2fd3",
      "d6671320-b614-4b44-a9e1-5eafbae25372"
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

  void createTournament() async {
    rounds.forEach((roundNumber, matches) async {
      final List<Map<String, dynamic>> allMatches = [];
      var json = jsonEncode(matches.map((e) => e.toJson()).toList());
      // for (final match in matches) {
      // allMatches.add(match.toJson());
      // await _supabase.rpc("save_player_ids", params: {"match_data": json});
      await _supabase.rpc('save_player_ids', params: {"match_data": json});
      return;
      // }
    });

    // print("je moeder");
    // await Supabase.instance.client.from('match').upsert(allMatches);
    // await Supabase.instance.client.from('match').insert(allMatches);
    // await _supabase.from("match").insert(allMatches);
  }
}
