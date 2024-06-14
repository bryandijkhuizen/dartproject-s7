// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'statistics_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$StatisticsStore on _StatisticsStore, Store {
  late final _$_matchesAtom =
      Atom(name: '_StatisticsStore._matches', context: context);

  @override
  ObservableList<MatchModel> get _matches {
    _$_matchesAtom.reportRead();
    return super._matches;
  }

  @override
  set _matches(ObservableList<MatchModel> value) {
    _$_matchesAtom.reportWrite(value, super._matches, () {
      super._matches = value;
    });
  }

  late final _$_playersAtom =
      Atom(name: '_StatisticsStore._players', context: context);

  @override
  ObservableList<PlayerModel> get _players {
    _$_playersAtom.reportRead();
    return super._players;
  }

  @override
  set _players(ObservableList<PlayerModel> value) {
    _$_playersAtom.reportWrite(value, super._players, () {
      super._players = value;
    });
  }

  late final _$_isLoadingAtom =
      Atom(name: '_StatisticsStore._isLoading', context: context);

  @override
  bool get _isLoading {
    _$_isLoadingAtom.reportRead();
    return super._isLoading;
  }

  @override
  set _isLoading(bool value) {
    _$_isLoadingAtom.reportWrite(value, super._isLoading, () {
      super._isLoading = value;
    });
  }

  late final _$_hasMoreAtom =
      Atom(name: '_StatisticsStore._hasMore', context: context);

  @override
  bool get _hasMore {
    _$_hasMoreAtom.reportRead();
    return super._hasMore;
  }

  @override
  set _hasMore(bool value) {
    _$_hasMoreAtom.reportWrite(value, super._hasMore, () {
      super._hasMore = value;
    });
  }

  late final _$fetchMatchesAsyncAction =
      AsyncAction('_StatisticsStore.fetchMatches', context: context);

  @override
  Future<void> fetchMatches({bool refresh = false}) {
    return _$fetchMatchesAsyncAction
        .run(() => super.fetchMatches(refresh: refresh));
  }

  late final _$_fetchPlayersAsyncAction =
      AsyncAction('_StatisticsStore._fetchPlayers', context: context);

  @override
  Future<void> _fetchPlayers() {
    return _$_fetchPlayersAsyncAction.run(() => super._fetchPlayers());
  }

  late final _$getMatchResultAsyncAction =
      AsyncAction('_StatisticsStore.getMatchResult', context: context);

  @override
  Future<String> getMatchResult(int matchId) {
    return _$getMatchResultAsyncAction.run(() => super.getMatchResult(matchId));
  }

  late final _$fetchMatchStatisticsAsyncAction =
      AsyncAction('_StatisticsStore.fetchMatchStatistics', context: context);

  @override
  Future<MatchStatisticsModel> fetchMatchStatistics(int currentMatchId) {
    return _$fetchMatchStatisticsAsyncAction
        .run(() => super.fetchMatchStatistics(currentMatchId));
  }

  late final _$calculateFinalScoreAsyncAction =
      AsyncAction('_StatisticsStore.calculateFinalScore', context: context);

  @override
  Future<String> calculateFinalScore(int matchId) {
    return _$calculateFinalScoreAsyncAction
        .run(() => super.calculateFinalScore(matchId));
  }

  late final _$_StatisticsStoreActionController =
      ActionController(name: '_StatisticsStore', context: context);

  @override
  void init() {
    final _$actionInfo = _$_StatisticsStoreActionController.startAction(
        name: '_StatisticsStore.init');
    try {
      return super.init();
    } finally {
      _$_StatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String getPlayerName(String playerId) {
    final _$actionInfo = _$_StatisticsStoreActionController.startAction(
        name: '_StatisticsStore.getPlayerName');
    try {
      return super.getPlayerName(playerId);
    } finally {
      _$_StatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void navigateToStatistics(String matchId) {
    final _$actionInfo = _$_StatisticsStoreActionController.startAction(
        name: '_StatisticsStore.navigateToStatistics');
    try {
      return super.navigateToStatistics(matchId);
    } finally {
      _$_StatisticsStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''

    ''';
  }
}
