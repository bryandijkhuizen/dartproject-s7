import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:backend/src/finish_calculator.dart';
import 'dart:async';

part 'match_store.g.dart';

class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  final SupabaseClient _supabaseClient;
  final String matchId;
  late final MatchModel matchModel;
  bool isFirstLeg = true;

  @observable
  bool setupComplete = false;

  @observable
  bool isCreatingSet = false;

  @observable
  bool isCreatingLeg = false;

  @observable
  ObservableList<Map<String, dynamic>> lastFiveScoresPlayer1 =
      ObservableList<Map<String, dynamic>>();
  @observable
  ObservableList<Map<String, dynamic>> lastFiveScoresPlayer2 =
      ObservableList<Map<String, dynamic>>();
  @observable
  ObservableList<Map<String, dynamic>> currentLegScores =
      ObservableList<Map<String, dynamic>>();

  @observable
  int currentLegId = -1;
  @observable
  int currentSetId = -1;
  @observable
  Map<String, int> legWins = {};
  @observable
  Map<String, int> setWins = {};

  @observable
  late int currentScorePlayer1;
  @observable
  late int currentScorePlayer2;
  @observable
  String? currentPlayerId;
  @observable
  String? matchWinnerId;

  @observable
  bool matchEnded = false;
  @observable
  String errorMessage = '';
  @observable
  bool isLoading = false;
  @observable
  String loadingMessage = 'Loading...';
  @observable
  String temporaryScore = '';

  @observable
  String player1Suggestion = '';
  @observable
  String player2Suggestion = '';
  @observable
  bool showPlayer1Suggestion = false;
  @observable
  bool showPlayer2Suggestion = false;
  @observable
  bool extraThrowAfterUndo = false;

  @observable
  bool doubleAttemptsNeeded = false;

  StreamSubscription<List<Map<String, dynamic>>>? turnSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? legSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? setSubscription;
  StreamSubscription<List<Map<String, dynamic>>>? matchSubscription;

  final FinishCalculator _finishCalculator = FinishCalculator();

  _MatchStore(this._supabaseClient, this.matchId) {
    _init();
  }

  @action
  Future<void> _init() async {
    if (setupComplete) return;

    isLoading = true;
    loadingMessage = 'Initializing match details...';
    try {
      var response = await _supabaseClient
          .from('match')
          .select('*')
          .eq('id', matchId)
          .single();
      matchModel = MatchModel.fromJson(response);

      await _fetchPlayerDetails();
      await _checkForActiveSetOrCreateNew();
      await _calculateWins();

      _subscribeToRealtimeUpdates();

      setupComplete = true;
    } catch (error) {
      errorMessage = 'Initialization failed: $error';
    } finally {
      isLoading = false;
    }
  }

  Future<void> _fetchPlayerDetails() async {
    try {
      var player1Response = await _supabaseClient
          .from('user')
          .select('last_name')
          .eq('id', matchModel.player1Id)
          .single();
      matchModel.player1LastName = player1Response['last_name'] ?? 'Unknown';
      var player2Response = await _supabaseClient
          .from('user')
          .select('last_name')
          .eq('id', matchModel.player2Id)
          .single();
      matchModel.player2LastName = player2Response['last_name'] ?? 'Unknown';

      currentScorePlayer1 = matchModel.startingScore;
      currentScorePlayer2 = matchModel.startingScore;
      currentPlayerId = matchModel.startingPlayerId;
    } catch (error) {
      errorMessage = 'Failed to fetch player details: $error';
    }
  }

  Future<void> _checkForActiveSetOrCreateNew() async {
    try {
      var response = await _supabaseClient
          .rpc('get_active_set', params: {'p_match_id': matchModel.id});
      if (response.isEmpty) {
        await _startNewSet();
      } else {
        final set = response[0];
        if (set['winner_id'] != null) {
          await _startNewSet();
        } else {
          currentSetId = set['set_id'];
          await _checkForActiveLegOrCreateNew();
        }
      }
    } catch (error) {
      errorMessage = 'Failed to check for active set: $error';
    }
  }

  Future<void> _checkForActiveLegOrCreateNew() async {
    try {
      var response = await _supabaseClient
          .rpc('get_active_leg', params: {'p_set_id': currentSetId});
      if (response.isEmpty) {
        await _startNewLeg();
      } else {
        final leg = response[0];
        if (leg['winner_id'] != null) {
          await _startNewLeg();
        } else {
          currentLegId = leg['leg_id'];
          await _restoreLatestScores();
        }
      }
    } catch (error) {
      errorMessage = 'Failed to check for active leg: $error';
    }
  }

  Future<void> _startNewSet() async {
    if (isCreatingSet) return;
    isCreatingSet = true;

    isLoading = true;
    loadingMessage = 'Starting new set...';
    try {
      var response = await _supabaseClient
          .rpc('create_set', params: {'p_match_id': matchModel.id});
      currentSetId = response[0]['set_id'];
      legWins.clear();
      if (!isFirstLeg) {
        _switchStartingPlayer();
      }
      isFirstLeg = false;
      currentPlayerId = matchModel.startingPlayerId;
      await _startNewLeg();
      _subscribeToSetUpdates(); // Voeg deze regel toe om opnieuw te abonneren bij nieuwe set
    } catch (error) {
      errorMessage = 'Failed to start a new set: $error';
    } finally {
      isLoading = false;
      isCreatingSet = false;
    }
  }

  @action
  Future<void> _startNewLeg() async {
    if (isCreatingLeg) return;
    isCreatingLeg = true;

    isLoading = true;
    loadingMessage = 'Starting new leg...';
    try {
      var response = await _supabaseClient
          .rpc('create_leg', params: {'p_set_id': currentSetId});
      currentLegId = response[0]['leg_id'];

      currentPlayerId = matchModel.startingPlayerId;

      currentScorePlayer1 = matchModel.startingScore;
      currentScorePlayer2 = matchModel.startingScore;

      lastFiveScoresPlayer1.clear();
      lastFiveScoresPlayer2.clear();

      _updateThrowSuggestions();

      await _supabaseClient
          .from('match')
          .update({'starting_player_id': matchModel.startingPlayerId}).eq(
              'id', matchModel.id);

      _subscribeToTurnUpdates();
    } catch (error) {
      errorMessage = 'Failed to start a new leg: $error';
    } finally {
      isLoading = false;
      isCreatingLeg = false;
    }
  }

  Future<void> _calculateWins() async {
    try {
      var legWinsResponse = await _supabaseClient
          .rpc('get_leg_wins', params: {'p_set_id': currentSetId});
      legWins = _aggregateWins(
          List<Map<String, dynamic>>.from(legWinsResponse), 'leg_winner_id');

      var setWinsResponse = await _supabaseClient
          .rpc('get_set_wins', params: {'p_match_id': matchId});
      setWins = _aggregateWins(
          List<Map<String, dynamic>>.from(setWinsResponse), 'set_winner_id');
    } catch (error) {
      errorMessage = 'Error calculating wins: $error';
    }
  }

  Map<String, int> _aggregateWins(
      List<Map<String, dynamic>> winsResponse, String winnerKey) {
    Map<String, int> wins = {};
    for (var win in winsResponse) {
      var winnerId = win[winnerKey]?.toString();
      if (winnerId != null) {
        wins[winnerId] = (wins[winnerId] ?? 0) + 1;
      }
    }
    return wins;
  }

  Future<void> _restoreLatestScores() async {
    if (currentLegId <= 0) {
      errorMessage = 'Invalid leg ID';
      return;
    }

    try {
      var turnResponse = await _supabaseClient
          .rpc('get_latest_scores', params: {'p_leg_id': currentLegId});

      if (turnResponse.isNotEmpty) {
        var latestTurn = turnResponse.first;

        currentScorePlayer1 = latestTurn['current_score'];
        currentScorePlayer2 = latestTurn['current_score2'];

        lastFiveScoresPlayer1.clear();
        lastFiveScoresPlayer2.clear();

        for (var turn in turnResponse) {
          final scoreEntry = {
            'score': turn['score'],
            'isDeadThrow': turn['score'] == 0,
          };
          if (turn['player_id'] == matchModel.player1Id) {
            lastFiveScoresPlayer1.add(scoreEntry);
          } else {
            lastFiveScoresPlayer2.add(scoreEntry);
          }
        }

        lastFiveScoresPlayer1 =
            ObservableList.of(lastFiveScoresPlayer1.take(5));
        lastFiveScoresPlayer2 =
            ObservableList.of(lastFiveScoresPlayer2.take(5));

        currentPlayerId = latestTurn['player_id'] == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;

        _updateThrowSuggestions();
      } else {
        currentScorePlayer1 = matchModel.startingScore;
        currentScorePlayer2 = matchModel.startingScore;
        lastFiveScoresPlayer1.clear();
        lastFiveScoresPlayer2.clear();
        _updateThrowSuggestions();
      }
    } catch (error) {
      errorMessage = 'Failed to restore scores: $error';
    }
  }

  @action
  Future<void> recordScore(int score,
      {int? dartsForCheckout, int? doubleAttempts}) async {
    if (score < 0 || score > 180) {
      errorMessage = 'Invalid score: $score';
      return;
    }

    try {
      bool doubleHit = false;
      int currentScore = currentPlayerId == matchModel.player1Id
          ? currentScorePlayer1
          : currentScorePlayer2;

      if (currentScore <= 50 && currentScore - score == 0) {
        if (dartsForCheckout == null || doubleAttempts == null) {
          doubleAttemptsNeeded = true;
          return;
        }
        doubleHit = true;
      }

      Map<String, dynamic> params = {
        'p_player_id': currentPlayerId,
        'p_new_leg_id': currentLegId,
        'p_score': score,
        'p_darts_for_checkout': dartsForCheckout,
        'p_double_attempts': doubleAttempts,
        'p_double_hit': doubleHit
      };

      final response = await _supabaseClient.rpc('record_turn', params: params);

      final legWinnerId =
          response.isNotEmpty ? response[0]['leg_winner_id'] : null;
      final newScore = response[0]['new_score'];
      final newScore2 = response[0]['new_score2'];
      final isDeadThrow = response[0]['is_dead_throw'] as bool;

      final displayScore = isDeadThrow ? 0 : score;

      _updateScores(newScore, newScore2, displayScore, isDeadThrow);

      if (legWinnerId != null) {
        await _updateLegWinner(legWinnerId.toString());
        await _endCurrentLeg(legWinnerId.toString());
      } else {
        if (extraThrowAfterUndo) {
          extraThrowAfterUndo = false;
        } else {
          currentPlayerId = currentPlayerId == matchModel.player1Id
              ? matchModel.player2Id
              : matchModel.player1Id;
        }
        _updateThrowSuggestions();
      }

      updateTemporaryScore('');
    } catch (error) {
      errorMessage = 'Failed to record score: $error';
    }
  }

  @action
  void updateTemporaryScore(String score) {
    temporaryScore = score;

    if (currentPlayerId == matchModel.player1Id) {
      showPlayer1Suggestion = true;
      final remainingScore =
          currentScorePlayer1 - (int.tryParse(temporaryScore) ?? 0);
      final player1SuggestionList =
          _finishCalculator.getThrowSuggestion(remainingScore, 3);
      player1Suggestion = player1SuggestionList?.join(', ') ?? '';
    } else {
      showPlayer2Suggestion = true;
      final remainingScore =
          currentScorePlayer2 - (int.tryParse(temporaryScore) ?? 0);
      final player2SuggestionList =
          _finishCalculator.getThrowSuggestion(remainingScore, 3);
      player2Suggestion = player2SuggestionList?.join(', ') ?? '';
    }
  }

  @action
  void _updateThrowSuggestions() {
    final player1SuggestionList =
        _finishCalculator.getThrowSuggestion(currentScorePlayer1, 3);
    final player2SuggestionList =
        _finishCalculator.getThrowSuggestion(currentScorePlayer2, 3);

    player1Suggestion = player1SuggestionList?.join(', ') ?? '';
    player2Suggestion = player2SuggestionList?.join(', ') ?? '';

    showPlayer1Suggestion = true;
    showPlayer2Suggestion = true;
  }

  void _updateScores(
      dynamic newScore, dynamic newScore2, int score, bool isDeadThrow) {
    final scoreEntry = {'score': score, 'isDeadThrow': isDeadThrow};
    if (currentPlayerId == matchModel.player1Id) {
      currentScorePlayer1 = newScore is int ? newScore : int.parse(newScore);
      lastFiveScoresPlayer1.add(scoreEntry);
      if (lastFiveScoresPlayer1.length > 5) {
        lastFiveScoresPlayer1.removeAt(0);
      }
    } else {
      currentScorePlayer2 = newScore2 is int ? newScore2 : int.parse(newScore2);
      lastFiveScoresPlayer2.add(scoreEntry);
      if (lastFiveScoresPlayer2.length > 5) {
        lastFiveScoresPlayer2.removeAt(0);
      }
    }
  }

  Future<void> _updateLegWinner(String legWinnerId) async {
    try {
      await _supabaseClient
          .from('leg')
          .update({'winner_id': legWinnerId}).eq('id', currentLegId);
    } catch (error) {
      errorMessage = 'Failed to update leg winner: $error';
    }
  }

  @action
  Future<void> undoLastScore() async {
    try {
      final response = await _supabaseClient
          .rpc('undo_last_score', params: {'p_leg_id': currentLegId});

      if (response != null && response.isNotEmpty) {
        final updatedCurrentScore = response[0]['updated_current_score'] as int;
        final updatedCurrentScore2 =
            response[0]['updated_current_score2'] as int;

        if (currentPlayerId == matchModel.player1Id) {
          currentScorePlayer1 = updatedCurrentScore;
          lastFiveScoresPlayer1.removeLast();
        } else {
          currentScorePlayer2 = updatedCurrentScore2;
          lastFiveScoresPlayer2.removeLast();
        }

        extraThrowAfterUndo = true;

        _updateThrowSuggestions();
      }
    } catch (error) {
      errorMessage = 'Failed to undo last score: $error';
    }
  }

  Future<void> _endCurrentLeg(String legWinnerId) async {
    try {
      legWins[legWinnerId] = (legWins[legWinnerId] ?? 0) + 1;
      await _updateLegWinner(legWinnerId);
      currentLegId = -1;
      if (legWins[legWinnerId] == matchModel.legTarget) {
        await _checkSetWinner(legWinnerId);
      } else {
        await _prepareForNextLeg(legWinnerId);
        await _startNewLeg();
      }
    } catch (error) {
      errorMessage = 'Failed to end current leg: $error';
    }
  }

  Future<void> _prepareForNextLeg(String legWinnerId) async {
    _switchStartingPlayer();
    currentPlayerId = matchModel.startingPlayerId;

    currentScorePlayer1 = matchModel.startingScore;
    currentScorePlayer2 = matchModel.startingScore;

    lastFiveScoresPlayer1.clear();
    lastFiveScoresPlayer2.clear();
    _updateThrowSuggestions();

    await _supabaseClient
        .from('match')
        .update({'starting_player_id': matchModel.startingPlayerId}).eq(
            'id', matchModel.id);

    _subscribeToTurnUpdates();
  }

  Future<void> _checkSetWinner(String setWinnerId) async {
    try {
      setWins[setWinnerId] = (setWins[setWinnerId] ?? 0) + 1;
      await _updateSetWinner(setWinnerId);
      if (setWins[setWinnerId] == matchModel.setTarget) {
        await _updateMatchWinner(setWinnerId);
        _endMatch(setWinnerId);
      } else {
        await _startNewSet();
      }
    } catch (error) {
      errorMessage = 'Failed to check set winner: $error';
    }
  }

  Future<void> _updateSetWinner(String setWinnerId) async {
    try {
      await _supabaseClient
          .from('set')
          .update({'winner_id': setWinnerId}).eq('id', currentSetId);
    } catch (error) {
      errorMessage = 'Failed to update set winner: $error';
    }
  }

  Future<void> _updateMatchWinner(String matchWinnerId) async {
    try {
      await _supabaseClient
          .from('match')
          .update({'winner_id': matchWinnerId}).eq('id', matchModel.id);
      matchModel.winnerId = matchWinnerId;
      matchEnded = true;
      _endMatch(matchWinnerId);
    } catch (error) {
      errorMessage = 'Failed to update match winner: $error';
    }
  }

  void _endMatch(String matchWinnerId) {
    matchEnded = true;
    this.matchWinnerId = matchWinnerId;
    loadingMessage =
        "Match has ended. Winner: Player ${matchWinnerId == matchModel.player1Id ? 1 : 2}";
  }

  void _switchStartingPlayer() {
    matchModel.startingPlayerId =
        matchModel.startingPlayerId == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
    _supabaseClient
        .from('match')
        .update({'starting_player_id': matchModel.startingPlayerId}).eq(
            'id', matchModel.id);
  }

  void _subscribeToRealtimeUpdates() {
    turnSubscription?.cancel();
    legSubscription?.cancel();
    setSubscription?.cancel();
    matchSubscription?.cancel();

    _subscribeToTurnUpdates();
    _subscribeToLegUpdates();
    _subscribeToSetUpdates();
    _subscribeToMatchUpdates();
  }

  void _subscribeToTurnUpdates() {
    turnSubscription?.cancel();
    turnSubscription = _supabaseClient
        .from('turn')
        .stream(primaryKey: ['id'])
        .eq('leg_id', currentLegId)
        .order('id', ascending: false)
        .listen((data) {
          if (data.isNotEmpty) {
            _updateScoresFromTurn(data);
          }
        });
  }

  void _subscribeToLegUpdates() {
    legSubscription?.cancel();
    legSubscription = _supabaseClient
        .from('leg')
        .stream(primaryKey: ['id'])
        .eq('set_id', currentSetId)
        .order('id', ascending: false)
        .listen((data) async {
          if (data.isNotEmpty) {
            var latestLeg = data.first;
            if (currentLegId != latestLeg['id']) {
              currentLegId = latestLeg['id'];
              if (currentLegId > 0) {
                await _restoreLatestScores();
                _subscribeToTurnUpdates();
              }
            }
            _calculateWins();
          }
        });
  }

  void _subscribeToSetUpdates() {
    setSubscription?.cancel();
    setSubscription = _supabaseClient
        .from('set')
        .stream(primaryKey: ['id'])
        .eq('match_id', matchId)
        .order('id', ascending: false)
        .listen((data) async {
          if (data.isNotEmpty) {
            var latestSet = data.first;
            if (currentSetId != latestSet['id']) {
              currentSetId = latestSet['id'];
              _calculateWins();
              await _checkForActiveSetOrCreateNew();
            }
          }
        });
  }

  void _subscribeToMatchUpdates() {
    matchSubscription?.cancel();
    matchSubscription = _supabaseClient
        .from('match')
        .stream(primaryKey: ['id'])
        .eq('id', matchId)
        .order('id', ascending: false)
        .listen((data) async {
          if (data.isNotEmpty) {
            matchModel = MatchModel.fromJson(data.first);
            if (matchModel.winnerId != null) {
              _endMatch(matchModel.winnerId!);
            } else {
              currentScorePlayer1 = matchModel.startingScore;
              currentScorePlayer2 = matchModel.startingScore;
              currentPlayerId = matchModel.startingPlayerId;
              lastFiveScoresPlayer1.clear();
              lastFiveScoresPlayer2.clear();
              await _fetchLegAndSetWins();
              _updateThrowSuggestions();
            }
          }
        });
  }

  void _updateScoresFromTurn(List<Map<String, dynamic>> data) {
    final latestTurn = data.first;

    currentScorePlayer1 = latestTurn['current_score'];
    currentScorePlayer2 = latestTurn['current_score2'];

    lastFiveScoresPlayer1.clear();
    lastFiveScoresPlayer2.clear();

    for (var turn in data) {
      final scoreEntry = {
        'score': turn['score'],
        'isDeadThrow': turn['score'] == 0,
      };
      if (turn['player_id'] == matchModel.player1Id) {
        lastFiveScoresPlayer1.add(scoreEntry);
      } else {
        lastFiveScoresPlayer2.add(scoreEntry);
      }
    }

    lastFiveScoresPlayer1 = ObservableList.of(lastFiveScoresPlayer1.take(5));
    lastFiveScoresPlayer2 = ObservableList.of(lastFiveScoresPlayer2.take(5));

    currentPlayerId = latestTurn['player_id'] == matchModel.player1Id
        ? matchModel.player2Id
        : matchModel.player1Id;

    _updateThrowSuggestions();
  }

  Future<void> _fetchLegAndSetWins() async {
    try {
      var legWinsResponse = await _supabaseClient
          .rpc('get_leg_wins', params: {'p_set_id': currentSetId});
      legWins = _aggregateWins(
          List<Map<String, dynamic>>.from(legWinsResponse), 'leg_winner_id');

      var setWinsResponse = await _supabaseClient
          .rpc('get_set_wins', params: {'p_match_id': matchId});
      setWins = _aggregateWins(
          List<Map<String, dynamic>>.from(setWinsResponse), 'set_winner_id');
    } catch (error) {
      errorMessage = 'Error fetching wins: $error';
    }
  }
}
