import 'package:darts_application/models/player.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'tournament_store.g.dart';

class TournamentStore = _TournamentStore with _$TournamentStore;

abstract class _TournamentStore with Store {
  final SupabaseClient _supabase;
  @observable
  bool initialized = false;
  @observable
  List<PlayerModel> unselectedPlayers;
  List<PlayerModel> selectedPlayers = [];

  _TournamentStore(
    this._supabase, {
    List<PlayerModel>? unselectedPlayers,
  }) : unselectedPlayers = unselectedPlayers ?? [];

  Future<List<PlayerModel>> loadPlayersByIds(List<String> playerIds) async {
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

    initialized = true;

    return playerModels;
  }

  // @action
  // selectPlayer(String playerName, int matchNumber) {
  //   unselectedPlayers.remove(playerName);
  //   selectedPlayers.add(playerName);
  // }

  // @computed
  // String get firstPlayer => unselectedPlayers.first;
}
