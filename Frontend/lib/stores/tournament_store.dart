import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  // @action
  // selectPlayer(String playerName, int matchNumber) {
  //   unselectedPlayers.remove(playerName);
  //   selectedPlayers.add(playerName);
  // }

  // @computed
  // String get firstPlayer => unselectedPlayers.first;
}
