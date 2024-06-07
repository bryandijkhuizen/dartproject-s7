import 'package:darts_application/exceptions/supabase_exception.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/services/match_service.dart';
import 'package:mobx/mobx.dart';

part 'next_match_store.g.dart';

class NextMatchStore = _NextMatchStore with _$NextMatchStore;

abstract class _NextMatchStore with Store {
  final MatchService _matchService;
  _NextMatchStore(this._matchService);

  @observable
  MatchModel? nextMatch;

  @observable
  String? nextMatchError;

  @action
  Future<void> loadNextMatch(String? userId) async {
    try {
      nextMatch = await _matchService.getNextMatch(userId);
      nextMatchError = null;
    } on SupabaseException catch (error) {
      nextMatch = null;
      nextMatchError = error.message;
    } catch (error) {
      print(error);
      nextMatch = null;
      nextMatchError = 'Unknown error occurred';
    }
  }
}
