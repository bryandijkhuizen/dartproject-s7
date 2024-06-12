import 'dart:convert';

import 'package:darts_application/features/clubs/stores/club_registration_view_store.dart';
import 'package:darts_application/models/tournament.dart';
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

  TournamentModel tournament;
  List<PlayerModel> players;
  late Map<int, List<Match>> rounds;
  @observable
  List<PlayerModel> unselectedPlayers;

  _TournamentStore(
    this._supabase,
    this.tournament,
    this.players,
    this.setTarget,
    this.legTarget,
    this.startingScore,
  ) : unselectedPlayers = players.toList() {
    _setup();
  }

  Future<void> _setup() async {
    rounds = createRounds(
      players,
      1,
      fillInPlayers: false,
    );

    initialized = true;
  }

  Future<Map<String, dynamic>> getPlayerById(String id) async {
    Map<String, dynamic> response =
        await _supabase.from('user').select('*').eq('id', id).single();

    return response;
  }

  Future<List<PlayerModel>> getPlayersByIds(List<String> playerIds) async {
    final dynamic response;
    try {
      response = await _supabase
          .rpc("get_users_by_uuids", params: {"uuid_list": playerIds});
    } catch (error) {
      throw Exception("An error occurred: $error");
    }

    if (response.isEmpty) {
      throw Exception(
          'Error fetching data: ${response.length} amount of user\'s found');
    }

    final List<dynamic> userData = response;

    List<PlayerModel> playerModels = userData.map((userMap) {
      return PlayerModel.fromJson(userMap);
    }).toList();

    return playerModels;
  }

  Map<int, List<Match>> createRounds(
    List<PlayerModel> players,
    int round, {
    bool fillInPlayers = false,
  }) {
    Map<int, List<Match>> rounds = {};

    List<Match> matches = addMatches(
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

      Map<int, List<Match>> nextRounds = createRounds(
        nextRoundPlayers,
        ++round,
        fillInPlayers: true,
      );

      rounds.addAll(nextRounds);
    }

    return rounds;
  }

  List<Match> addMatches(
    List<PlayerModel> players, {
    bool fillInPlayers = false,
  }) {
    List<Match> matches = [];
    int amountOfPlayers = players.length;
    int amountOfMatches = (amountOfPlayers / 2).ceil();

    while (amountOfMatches >= 1) {
      Match newMatch;

      if (fillInPlayers) {
        PlayerModel? firstPlayer =
            players.isNotEmpty ? players.removeAt(0) : null;
        PlayerModel? secondPlayer =
            players.isNotEmpty ? players.removeAt(0) : null;

        newMatch = addMatch(
          tournament.startTime,
          setTarget,
          legTarget,
          firstPlayer: firstPlayer,
          secondPlayer: secondPlayer,
          location: tournament.location,
          player1LastName: firstPlayer?.lastName,
          player2LastName: secondPlayer?.lastName,
        );
      } else {
        newMatch = addMatch(
          tournament.startTime,
          setTarget,
          legTarget,
          location: tournament.location,
          player1LastName: "",
          player2LastName: "",
        );
      }

      matches.add(newMatch);

      amountOfMatches--;
    }

    return matches;
  }

  Match addMatch(
    DateTime date,
    int setTarget,
    int legTarget, {
    int? id,
    PlayerModel? firstPlayer,
    PlayerModel? secondPlayer,
    String? location,
    String? player1LastName,
    String? player2LastName,
  }) {
    final Match newMatch = Match(
      player1Id: firstPlayer?.id,
      player2Id: secondPlayer?.id,
      date: date,
      setTarget: setTarget,
      legTarget: legTarget,
      startingScore: startingScore,
      player1LastName: firstPlayer?.lastName ?? player1LastName,
      player2LastName: secondPlayer?.lastName ?? player2LastName,
    );

    if (id != null) {
      newMatch.id = id;
    }

    if (location == null) {
      newMatch.location = location;
    }

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
      Match match = rounds[roundNumber]![matchIndex];
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
      Match match = rounds[roundNumber]![matchIndex];

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
    try {
      rounds.forEach(
        (roundNumber, matches) async {
          var json = jsonEncode(matches);
          Map<String, dynamic> resultJson = await _supabase
              .rpc<Map<String, dynamic>>('create_tournament_round', params: {
            "match_data": matches,
            'current_tournament_id': tournament.id,
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
        success: true, message: 'Successfully created tournament');
  }
}

class SupabaseException implements Exception {
  String cause;
  SupabaseException(this.cause);
}
