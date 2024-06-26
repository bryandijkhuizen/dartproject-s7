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
    try {
      Map<String, dynamic> response =
          await _supabase.from('user').select('*').eq('id', id).single();
      return response;
    } catch (error) {
      throw Exception("An error occurred $error");
    }
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

    // Create next round
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
    int amountOfMatches = (players.length / 2).ceil();

    while (amountOfMatches >= 1) {
      Match newMatch;

      if (fillInPlayers) {
        PlayerModel? firstPlayer =
            players.isNotEmpty ? players.removeAt(0) : null;
        PlayerModel? secondPlayer =
            players.isNotEmpty ? players.removeAt(0) : null;

        newMatch = getMatch(
          tournament.startTime,
          firstPlayer: firstPlayer,
          secondPlayer: secondPlayer,
          location: tournament.location,
          player1LastName: firstPlayer?.lastName,
          player2LastName: secondPlayer?.lastName,
        );
      } else {
        newMatch = getMatch(
          tournament.startTime,
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

  Match getMatch(
    DateTime date, {
    int? id,
    PlayerModel? firstPlayer,
    PlayerModel? secondPlayer,
    int? setTarget,
    int? legTarget,
    int? startingScore,
    String? location,
    String? player1LastName,
    String? player2LastName,
  }) {
    final Match newMatch = Match(
      player1Id: firstPlayer?.id,
      player2Id: secondPlayer?.id,
      date: date,
      setTarget: setTarget ?? this.setTarget,
      legTarget: legTarget ?? this.legTarget,
      startingScore: startingScore ?? this.startingScore,
      player1LastName: firstPlayer?.lastName ?? player1LastName,
      player2LastName: secondPlayer?.lastName ?? player2LastName,
    );

    if (id != null) newMatch.id = id;
    if (location != null) newMatch.location = location;

    return newMatch;
  }

  PlayerModel getPlayerFromPlayers(String playerId) {
    if (playerId == "") throw Exception("No playerId is given.");
    if (players.isEmpty) throw Exception("There are no players in Tournament");

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

      print(
          'Player in match $matchIndex in round $roundNumber unselected successfully.');
    } on RangeError {
      print(
          'Error: Index out of bounds. Please check the range of matchIndex.');
    } on NoSuchMethodError {
      print('Error: The item at matchIndex is null or not found.');
    } catch (error) {
      print('There was an error: $error');
    }
  }

  void selectPlayer(
    PlayerModel player,
    int roundNumber,
    int matchIndex,
    bool isFirstPlayer,
  ) {
    try {
      Match match = rounds[roundNumber]![matchIndex];

      if (isFirstPlayer) {
        match.player1Id = player.id;
        match.player1LastName = player.lastName;
      } else {
        match.player2Id = player.id;
        match.player2LastName = player.lastName;
      }

      print(
          'Player in match $matchIndex in round $roundNumber selected successfully.');
    } on RangeError {
      print(
          'Error: Index out of bounds. Please check the range of matchIndex.');
    } on NoSuchMethodError {
      print('Error: The item at matchIndex is null or not found.');
    } catch (error) {
      print('There was an error: $error');
    }

    // Remove player from unselectedPlayers
    unselectedPlayers.removeWhere(
      (unselectedPlayer) => unselectedPlayer.id == player.id,
    );
  }

  bool checkIfFirstRoundIsFull(){
    List<Match> matches = rounds[1]!;
    for (var match in matches) {
      if(match.player1Id == null || match.player2Id == null){
        return false;
      }
    }
    return true;
  }

  Future<SupabaseResultType> createTournament() async {
    if(!checkIfFirstRoundIsFull()){return const SupabaseResultType(success: false, message: "Fill in all players");}
    try {
      rounds.forEach(
        (roundNumber, matches) async {
          Map<String, dynamic> resultJson =
              await _supabase.rpc<Map<String, dynamic>>(
            'create_tournament_round',
            params: {
              "match_data": matches,
              'current_tournament_id': tournament.id,
              'current_round_number': roundNumber
            },
          );

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
      success: true,
      message: 'Successfully created tournament',
    );
  }
}

class SupabaseException implements Exception {
  String cause;
  SupabaseException(this.cause);
}
