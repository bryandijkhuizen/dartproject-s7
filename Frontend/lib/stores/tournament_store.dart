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

  // TournamentModel tournament;
  List<PlayerModel> players;
  late Map<int, List<MatchModel>> rounds;
  @observable
  List<PlayerModel> unselectedPlayers;

  _TournamentStore(
    this._supabase,
    // this.tournament,
    this.players,
    this.setTarget,
    this.legTarget,
    this.startingScore,
  ) : unselectedPlayers = players.toList() {
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
      "a58337bd-a24a-41d8-9154-58860a25fbf0",
      "3d835c6e-5c6c-448a-9fee-23257fab77de",
      "116c3801-3fd7-435a-8c30-bf70ccd3793e",
      "4494eb42-d241-4c2e-9570-5ae26205d2f4",
      "b8499eb2-d152-45c0-9ddd-7acc5d5c3cba",
      "a7c1275a-83c8-4c80-a347-505b49e74163",
      "278063b3-c29f-47ed-bf19-162b1b87891d",
      "63a7429e-0f35-4280-b003-a52c5218e5f0",
      "0df4520b-723a-455c-897d-26ca475201fe",
      "6676453c-7c41-4371-bad6-1c5389d50bc5",
      "779e8d67-d298-499b-8d48-b1d192eeb8d7",
      "8b8d4da1-8db3-45b9-96cb-57afad1ffb88",
      "2646b1ed-01dc-44c4-b149-2aede7673b04",
      "ed02cf94-9405-4eac-bd13-5fc6155859d1",
      "dc1ce331-d1f6-425d-a1c1-f5042570a9cc",
      "6770730e-878a-400d-98df-255693c36fb9"
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
    int tournament_id = 1;
    try {
      rounds.forEach(
        (roundNumber, matches) async {
          var json = jsonEncode(matches);
          Map<String, dynamic> resultJson = await _supabase
              .rpc<Map<String, dynamic>>('create_tournament_round', params: {
            "match_data": matches,
            'current_tournament_id': tournament_id,
            'current_round_number': roundNumber
          });

          SupabaseResultType result = SupabaseResultType.fromJson(resultJson);
          if (!result.success) {
            throw SupabaseException(result.message);
          }
        },
      );
    } on SupabaseException catch (e) {
      return SupabaseResultType(
        success: false,
        message: e.cause,
      );
    } catch (e) {
      return const SupabaseResultType(
        success: false,
        message: 'Unknown error occurred.',
      );
    }
    return const SupabaseResultType(
        success: true, message: 'Succesfully created tournament');
  }
}

class SupabaseException implements Exception {
  String cause;
  SupabaseException(this.cause);
}
