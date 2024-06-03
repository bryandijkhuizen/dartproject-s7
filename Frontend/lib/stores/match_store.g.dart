// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'match_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$MatchStore on _MatchStore, Store {
  late final _$setupCompleteAtom =
      Atom(name: '_MatchStore.setupComplete', context: context);

  @override
  bool get setupComplete {
    _$setupCompleteAtom.reportRead();
    return super.setupComplete;
  }

  @override
  set setupComplete(bool value) {
    _$setupCompleteAtom.reportWrite(value, super.setupComplete, () {
      super.setupComplete = value;
    });
  }

  late final _$isCreatingSetAtom =
      Atom(name: '_MatchStore.isCreatingSet', context: context);

  @override
  bool get isCreatingSet {
    _$isCreatingSetAtom.reportRead();
    return super.isCreatingSet;
  }

  @override
  set isCreatingSet(bool value) {
    _$isCreatingSetAtom.reportWrite(value, super.isCreatingSet, () {
      super.isCreatingSet = value;
    });
  }

  late final _$isCreatingLegAtom =
      Atom(name: '_MatchStore.isCreatingLeg', context: context);

  @override
  bool get isCreatingLeg {
    _$isCreatingLegAtom.reportRead();
    return super.isCreatingLeg;
  }

  @override
  set isCreatingLeg(bool value) {
    _$isCreatingLegAtom.reportWrite(value, super.isCreatingLeg, () {
      super.isCreatingLeg = value;
    });
  }

  late final _$lastFiveScoresPlayer1Atom =
      Atom(name: '_MatchStore.lastFiveScoresPlayer1', context: context);

  @override
  ObservableList<Map<String, dynamic>> get lastFiveScoresPlayer1 {
    _$lastFiveScoresPlayer1Atom.reportRead();
    return super.lastFiveScoresPlayer1;
  }

  @override
  set lastFiveScoresPlayer1(ObservableList<Map<String, dynamic>> value) {
    _$lastFiveScoresPlayer1Atom.reportWrite(value, super.lastFiveScoresPlayer1,
        () {
      super.lastFiveScoresPlayer1 = value;
    });
  }

  late final _$lastFiveScoresPlayer2Atom =
      Atom(name: '_MatchStore.lastFiveScoresPlayer2', context: context);

  @override
  ObservableList<Map<String, dynamic>> get lastFiveScoresPlayer2 {
    _$lastFiveScoresPlayer2Atom.reportRead();
    return super.lastFiveScoresPlayer2;
  }

  @override
  set lastFiveScoresPlayer2(ObservableList<Map<String, dynamic>> value) {
    _$lastFiveScoresPlayer2Atom.reportWrite(value, super.lastFiveScoresPlayer2,
        () {
      super.lastFiveScoresPlayer2 = value;
    });
  }

  late final _$currentLegScoresAtom =
      Atom(name: '_MatchStore.currentLegScores', context: context);

  @override
  ObservableList<Map<String, dynamic>> get currentLegScores {
    _$currentLegScoresAtom.reportRead();
    return super.currentLegScores;
  }

  @override
  set currentLegScores(ObservableList<Map<String, dynamic>> value) {
    _$currentLegScoresAtom.reportWrite(value, super.currentLegScores, () {
      super.currentLegScores = value;
    });
  }

  late final _$currentLegIdAtom =
      Atom(name: '_MatchStore.currentLegId', context: context);

  @override
  int get currentLegId {
    _$currentLegIdAtom.reportRead();
    return super.currentLegId;
  }

  @override
  set currentLegId(int value) {
    _$currentLegIdAtom.reportWrite(value, super.currentLegId, () {
      super.currentLegId = value;
    });
  }

  late final _$currentSetIdAtom =
      Atom(name: '_MatchStore.currentSetId', context: context);

  @override
  int get currentSetId {
    _$currentSetIdAtom.reportRead();
    return super.currentSetId;
  }

  @override
  set currentSetId(int value) {
    _$currentSetIdAtom.reportWrite(value, super.currentSetId, () {
      super.currentSetId = value;
    });
  }

  late final _$legWinsAtom =
      Atom(name: '_MatchStore.legWins', context: context);

  @override
  Map<String, int> get legWins {
    _$legWinsAtom.reportRead();
    return super.legWins;
  }

  @override
  set legWins(Map<String, int> value) {
    _$legWinsAtom.reportWrite(value, super.legWins, () {
      super.legWins = value;
    });
  }

  late final _$setWinsAtom =
      Atom(name: '_MatchStore.setWins', context: context);

  @override
  Map<String, int> get setWins {
    _$setWinsAtom.reportRead();
    return super.setWins;
  }

  @override
  set setWins(Map<String, int> value) {
    _$setWinsAtom.reportWrite(value, super.setWins, () {
      super.setWins = value;
    });
  }

  late final _$currentScorePlayer1Atom =
      Atom(name: '_MatchStore.currentScorePlayer1', context: context);

  @override
  int get currentScorePlayer1 {
    _$currentScorePlayer1Atom.reportRead();
    return super.currentScorePlayer1;
  }

  bool _currentScorePlayer1IsInitialized = false;

  @override
  set currentScorePlayer1(int value) {
    _$currentScorePlayer1Atom.reportWrite(value,
        _currentScorePlayer1IsInitialized ? super.currentScorePlayer1 : null,
        () {
      super.currentScorePlayer1 = value;
      _currentScorePlayer1IsInitialized = true;
    });
  }

  late final _$currentScorePlayer2Atom =
      Atom(name: '_MatchStore.currentScorePlayer2', context: context);

  @override
  int get currentScorePlayer2 {
    _$currentScorePlayer2Atom.reportRead();
    return super.currentScorePlayer2;
  }

  bool _currentScorePlayer2IsInitialized = false;

  @override
  set currentScorePlayer2(int value) {
    _$currentScorePlayer2Atom.reportWrite(value,
        _currentScorePlayer2IsInitialized ? super.currentScorePlayer2 : null,
        () {
      super.currentScorePlayer2 = value;
      _currentScorePlayer2IsInitialized = true;
    });
  }

  late final _$currentPlayerIdAtom =
      Atom(name: '_MatchStore.currentPlayerId', context: context);

  @override
  String? get currentPlayerId {
    _$currentPlayerIdAtom.reportRead();
    return super.currentPlayerId;
  }

  @override
  set currentPlayerId(String? value) {
    _$currentPlayerIdAtom.reportWrite(value, super.currentPlayerId, () {
      super.currentPlayerId = value;
    });
  }

  late final _$matchWinnerIdAtom =
      Atom(name: '_MatchStore.matchWinnerId', context: context);

  @override
  String? get matchWinnerId {
    _$matchWinnerIdAtom.reportRead();
    return super.matchWinnerId;
  }

  @override
  set matchWinnerId(String? value) {
    _$matchWinnerIdAtom.reportWrite(value, super.matchWinnerId, () {
      super.matchWinnerId = value;
    });
  }

  late final _$matchEndedAtom =
      Atom(name: '_MatchStore.matchEnded', context: context);

  @override
  bool get matchEnded {
    _$matchEndedAtom.reportRead();
    return super.matchEnded;
  }

  @override
  set matchEnded(bool value) {
    _$matchEndedAtom.reportWrite(value, super.matchEnded, () {
      super.matchEnded = value;
    });
  }

  late final _$errorMessageAtom =
      Atom(name: '_MatchStore.errorMessage', context: context);

  @override
  String get errorMessage {
    _$errorMessageAtom.reportRead();
    return super.errorMessage;
  }

  @override
  set errorMessage(String value) {
    _$errorMessageAtom.reportWrite(value, super.errorMessage, () {
      super.errorMessage = value;
    });
  }

  late final _$isLoadingAtom =
      Atom(name: '_MatchStore.isLoading', context: context);

  @override
  bool get isLoading {
    _$isLoadingAtom.reportRead();
    return super.isLoading;
  }

  @override
  set isLoading(bool value) {
    _$isLoadingAtom.reportWrite(value, super.isLoading, () {
      super.isLoading = value;
    });
  }

  late final _$loadingMessageAtom =
      Atom(name: '_MatchStore.loadingMessage', context: context);

  @override
  String get loadingMessage {
    _$loadingMessageAtom.reportRead();
    return super.loadingMessage;
  }

  @override
  set loadingMessage(String value) {
    _$loadingMessageAtom.reportWrite(value, super.loadingMessage, () {
      super.loadingMessage = value;
    });
  }

  late final _$temporaryScoreAtom =
      Atom(name: '_MatchStore.temporaryScore', context: context);

  @override
  String get temporaryScore {
    _$temporaryScoreAtom.reportRead();
    return super.temporaryScore;
  }

  @override
  set temporaryScore(String value) {
    _$temporaryScoreAtom.reportWrite(value, super.temporaryScore, () {
      super.temporaryScore = value;
    });
  }

  late final _$player1SuggestionAtom =
      Atom(name: '_MatchStore.player1Suggestion', context: context);

  @override
  String get player1Suggestion {
    _$player1SuggestionAtom.reportRead();
    return super.player1Suggestion;
  }

  @override
  set player1Suggestion(String value) {
    _$player1SuggestionAtom.reportWrite(value, super.player1Suggestion, () {
      super.player1Suggestion = value;
    });
  }

  late final _$player2SuggestionAtom =
      Atom(name: '_MatchStore.player2Suggestion', context: context);

  @override
  String get player2Suggestion {
    _$player2SuggestionAtom.reportRead();
    return super.player2Suggestion;
  }

  @override
  set player2Suggestion(String value) {
    _$player2SuggestionAtom.reportWrite(value, super.player2Suggestion, () {
      super.player2Suggestion = value;
    });
  }

  late final _$showPlayer1SuggestionAtom =
      Atom(name: '_MatchStore.showPlayer1Suggestion', context: context);

  @override
  bool get showPlayer1Suggestion {
    _$showPlayer1SuggestionAtom.reportRead();
    return super.showPlayer1Suggestion;
  }

  @override
  set showPlayer1Suggestion(bool value) {
    _$showPlayer1SuggestionAtom.reportWrite(value, super.showPlayer1Suggestion,
        () {
      super.showPlayer1Suggestion = value;
    });
  }

  late final _$showPlayer2SuggestionAtom =
      Atom(name: '_MatchStore.showPlayer2Suggestion', context: context);

  @override
  bool get showPlayer2Suggestion {
    _$showPlayer2SuggestionAtom.reportRead();
    return super.showPlayer2Suggestion;
  }

  @override
  set showPlayer2Suggestion(bool value) {
    _$showPlayer2SuggestionAtom.reportWrite(value, super.showPlayer2Suggestion,
        () {
      super.showPlayer2Suggestion = value;
    });
  }

  late final _$extraThrowAfterUndoAtom =
      Atom(name: '_MatchStore.extraThrowAfterUndo', context: context);

  @override
  bool get extraThrowAfterUndo {
    _$extraThrowAfterUndoAtom.reportRead();
    return super.extraThrowAfterUndo;
  }

  @override
  set extraThrowAfterUndo(bool value) {
    _$extraThrowAfterUndoAtom.reportWrite(value, super.extraThrowAfterUndo, () {
      super.extraThrowAfterUndo = value;
    });
  }

  late final _$doubleAttemptsNeededAtom =
      Atom(name: '_MatchStore.doubleAttemptsNeeded', context: context);

  @override
  bool get doubleAttemptsNeeded {
    _$doubleAttemptsNeededAtom.reportRead();
    return super.doubleAttemptsNeeded;
  }

  @override
  set doubleAttemptsNeeded(bool value) {
    _$doubleAttemptsNeededAtom.reportWrite(value, super.doubleAttemptsNeeded,
        () {
      super.doubleAttemptsNeeded = value;
    });
  }

  late final _$_initAsyncAction =
      AsyncAction('_MatchStore._init', context: context);

  @override
  Future<void> _init() {
    return _$_initAsyncAction.run(() => super._init());
  }

  late final _$_startNewLegAsyncAction =
      AsyncAction('_MatchStore._startNewLeg', context: context);

  @override
  Future<void> _startNewLeg() {
    return _$_startNewLegAsyncAction.run(() => super._startNewLeg());
  }

  late final _$recordScoreAsyncAction =
      AsyncAction('_MatchStore.recordScore', context: context);

  @override
  Future<void> recordScore(int score,
      {int? dartsForCheckout, int? doubleAttempts}) {
    return _$recordScoreAsyncAction.run(() => super.recordScore(score,
        dartsForCheckout: dartsForCheckout, doubleAttempts: doubleAttempts));
  }

  late final _$_promptForDartsForCheckoutAsyncAction =
      AsyncAction('_MatchStore._promptForDartsForCheckout', context: context);

  @override
  Future<int> _promptForDartsForCheckout() {
    return _$_promptForDartsForCheckoutAsyncAction
        .run(() => super._promptForDartsForCheckout());
  }

  late final _$_promptForDoubleAttemptsAsyncAction =
      AsyncAction('_MatchStore._promptForDoubleAttempts', context: context);

  @override
  Future<int> _promptForDoubleAttempts() {
    return _$_promptForDoubleAttemptsAsyncAction
        .run(() => super._promptForDoubleAttempts());
  }

  late final _$undoLastScoreAsyncAction =
      AsyncAction('_MatchStore.undoLastScore', context: context);

  @override
  Future<void> undoLastScore() {
    return _$undoLastScoreAsyncAction.run(() => super.undoLastScore());
  }

  late final _$_MatchStoreActionController =
      ActionController(name: '_MatchStore', context: context);

  @override
  void updateTemporaryScore(String score) {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore.updateTemporaryScore');
    try {
      return super.updateTemporaryScore(score);
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void _updateThrowSuggestions() {
    final _$actionInfo = _$_MatchStoreActionController.startAction(
        name: '_MatchStore._updateThrowSuggestions');
    try {
      return super._updateThrowSuggestions();
    } finally {
      _$_MatchStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
setupComplete: ${setupComplete},
isCreatingSet: ${isCreatingSet},
isCreatingLeg: ${isCreatingLeg},
lastFiveScoresPlayer1: ${lastFiveScoresPlayer1},
lastFiveScoresPlayer2: ${lastFiveScoresPlayer2},
currentLegScores: ${currentLegScores},
currentLegId: ${currentLegId},
currentSetId: ${currentSetId},
legWins: ${legWins},
setWins: ${setWins},
currentScorePlayer1: ${currentScorePlayer1},
currentScorePlayer2: ${currentScorePlayer2},
currentPlayerId: ${currentPlayerId},
matchWinnerId: ${matchWinnerId},
matchEnded: ${matchEnded},
errorMessage: ${errorMessage},
isLoading: ${isLoading},
loadingMessage: ${loadingMessage},
temporaryScore: ${temporaryScore},
player1Suggestion: ${player1Suggestion},
player2Suggestion: ${player2Suggestion},
showPlayer1Suggestion: ${showPlayer1Suggestion},
showPlayer2Suggestion: ${showPlayer2Suggestion},
extraThrowAfterUndo: ${extraThrowAfterUndo},
doubleAttemptsNeeded: ${doubleAttemptsNeeded}
    ''';
  }
}
