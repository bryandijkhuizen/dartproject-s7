import 'package:darts_application/exceptions/dart_game_exception.dart';
import 'package:darts_application/models/match.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'match_store.g.dart';

class MatchStore = _MatchStoreBase with _$MatchStore;

abstract class _MatchStoreBase with Store {
  final SupabaseClient _client;
  final MatchModel _match;
  _MatchStoreBase(this._client, this._match);
  
  @computed
  String get player1LastName => _match.player1LastName;
}