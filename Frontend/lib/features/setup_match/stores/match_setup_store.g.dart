// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_setup_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MatchSetupStore on _MatchSetupStore, Store {
  late final _$fetchMatchesAsyncAction =
      AsyncAction('_MatchSetupStore.fetchMatches', context: context);

  @override
  Future<Map<String, List<MatchModel>>> fetchMatches() {
    return _$fetchMatchesAsyncAction.run(() => super.fetchMatches());
  }

  late final _$matchAlreadyStartedAsyncAction =
      AsyncAction('_MatchSetupStore.matchAlreadyStarted', context: context);

  @override
  Future<bool> matchAlreadyStarted(dynamic matches, dynamic matchID) {
    return _$matchAlreadyStartedAsyncAction
        .run(() => super.matchAlreadyStarted(matches, matchID));
  }

  late final _$updateStartingPlayerAsyncAction =
      AsyncAction('_MatchSetupStore.updateStartingPlayer', context: context);

  @override
  Future<void> updateStartingPlayer(dynamic playerId, dynamic matchId) {
    return _$updateStartingPlayerAsyncAction
        .run(() => super.updateStartingPlayer(playerId, matchId));
  }

  late final _$_MatchSetupStoreActionController =
      ActionController(name: '_MatchSetupStore', context: context);

  @override
  void redirectToGameplay(dynamic matchId) {
    final _$actionInfo = _$_MatchSetupStoreActionController.startAction(
        name: '_MatchSetupStore.redirectToGameplay');
    try {
      return super.redirectToGameplay(matchId);
    } finally {
      _$_MatchSetupStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
