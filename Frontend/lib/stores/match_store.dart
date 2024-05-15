import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';

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

      subscribeToScores();

      setupComplete = true;
    } catch (error) {
      errorMessage = 'Initialization failed: $error';
      print('Error during initialization: $error');
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
      print('Error fetching player details: $error');
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
      print('Error checking for active set: $error');
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
      print('Error checking for active leg: $error');
    }
  }

  Future<void> _startNewSet() async {
    if (isCreatingSet || currentSetId != -1) return; // Prevent duplicate sets
    isCreatingSet = true;

    isLoading = true;
    loadingMessage = 'Starting new set...';
    try {
      var response = await _supabaseClient
          .rpc('create_set', params: {'p_match_id': matchModel.id});
      currentSetId = response[0]['set_id'];
      await _startNewLeg();
    } catch (error) {
      errorMessage = 'Failed to start a new set: $error';
      print('Error starting new set: $error');
    } finally {
      isLoading = false;
      isCreatingSet = false;
    }
  }

  Future<void> _startNewLeg() async {
    if (isCreatingLeg) return; // Prevent duplicate legs
    isCreatingLeg = true;

    isLoading = true;
    loadingMessage = 'Starting new leg...';
    try {
      var response = await _supabaseClient
          .rpc('create_leg', params: {'p_set_id': currentSetId});
      currentLegId = response[0]['leg_id'];

      // Set the current player to the starting player for this leg
      currentPlayerId = matchModel.startingPlayerId;

      currentScorePlayer1 = matchModel.startingScore;
      currentScorePlayer2 = matchModel.startingScore;

      lastFiveScoresPlayer1.clear();
      lastFiveScoresPlayer2.clear();
    } catch (error) {
      errorMessage = 'Failed to start a new leg: $error';
      print('Error starting new leg: $error');
    } finally {
      isLoading = false;
      isCreatingLeg = false;
    }
  }

  Future<void> _calculateWins() async {
    try {
      var legWinsResponse = await _supabaseClient
          .rpc('get_leg_wins', params: {'p_set_id': currentSetId});
      legWins =
          _aggregateWins(List<Map<String, dynamic>>.from(legWinsResponse));

      var setWinsResponse = await _supabaseClient
          .rpc('get_set_wins', params: {'p_match_id': matchId});
      setWins =
          _aggregateWins(List<Map<String, dynamic>>.from(setWinsResponse));
    } catch (error) {
      errorMessage = 'Error calculating wins: $error';
      print('Error calculating wins: $error');
    }
  }

  Map<String, int> _aggregateWins(List<Map<String, dynamic>> winsResponse) {
    Map<String, int> wins = {};
    for (var win in winsResponse) {
      var winnerId = win['leg_winner_id']?.toString();
      if (winnerId != null) {
        wins[winnerId] = (wins[winnerId] ?? 0) + 1;
      }
    }
    return wins;
  }

  Future<void> _restoreLatestScores() async {
    try {
      var turnResponse = await _supabaseClient
          .rpc('get_latest_scores', params: {'p_leg_id': currentLegId});
      if (turnResponse.isNotEmpty) {
        currentScorePlayer1 = turnResponse.first['current_score'];
        currentScorePlayer2 = turnResponse.first['current_score2'];

        lastFiveScoresPlayer1.clear();
        lastFiveScoresPlayer2.clear();

        for (var turn in turnResponse) {
          final scoreEntry = {
            'score': turn['score'],
            'isDeadThrow': turn['score'] == 0
          };
          if (turn['player_id'] == matchModel.player1Id) {
            lastFiveScoresPlayer1.insert(0, scoreEntry);
          } else {
            lastFiveScoresPlayer2.insert(0, scoreEntry);
          }
        }

        // Correctly sort and limit the scores
        lastFiveScoresPlayer1 =
            ObservableList.of(lastFiveScoresPlayer1.take(5));
        lastFiveScoresPlayer2 =
            ObservableList.of(lastFiveScoresPlayer2.take(5));

        // Ensure currentPlayerId is set correctly for the next turn
        currentPlayerId = turnResponse.first['player_id'] == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
      }
    } catch (error) {
      errorMessage = 'Failed to restore scores: $error';
      print('Error restoring scores: $error');
    }
  }

  @action
  Future<void> recordScore(int score) async {
    if (score < 0 || score > 180) {
      errorMessage = 'Invalid score: $score';
      return;
    }
    try {
      final response = await _supabaseClient.rpc('record_turn', params: {
        'p_player_id': currentPlayerId,
        'p_new_leg_id': currentLegId,
        'p_score': score
      });

      final legWinnerId = response[0]['leg_winner_id'];
      final newScore = response[0]['new_score'];
      final newScore2 = response[0]['new_score2'];
      final isDeadThrow = response[0]['is_dead_throw'] as bool;

      _updateScores(newScore, newScore2, score, isDeadThrow);

      if (legWinnerId != null) {
        await _updateLegWinner(legWinnerId.toString());
        await _endCurrentLeg(legWinnerId.toString());
      } else {
        currentPlayerId = currentPlayerId == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
      }

      updateTemporaryScore('');
    } catch (error) {
      errorMessage = 'Failed to record score: $error';
      print('Error recording score: $error');
    }
  }

  void _updateScores(
      dynamic newScore, dynamic newScore2, int score, bool isDeadThrow) {
    final scoreEntry = {'score': score, 'isDeadThrow': isDeadThrow};
    if (currentPlayerId == matchModel.player1Id) {
      currentScorePlayer1 = newScore is int ? newScore : int.parse(newScore);
      lastFiveScoresPlayer1.insert(0, scoreEntry);
      if (lastFiveScoresPlayer1.length > 5) {
        lastFiveScoresPlayer1.removeLast();
      }
    } else {
      currentScorePlayer2 = newScore2 is int ? newScore2 : int.parse(newScore2);
      lastFiveScoresPlayer2.insert(0, scoreEntry);
      if (lastFiveScoresPlayer2.length > 5) {
        lastFiveScoresPlayer2.removeLast();
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
      print('Error updating leg winner: $error');
    }
  }

  @action
  Future<void> undoLastScore() async {
    try {
      final lastScoreEntry = currentPlayerId == matchModel.player1Id
          ? (lastFiveScoresPlayer1.isNotEmpty
              ? lastFiveScoresPlayer1.last
              : {'score': 0})
          : (lastFiveScoresPlayer2.isNotEmpty
              ? lastFiveScoresPlayer2.last
              : {'score': 0});

      final lastScore = lastScoreEntry['score'] as int;

      final response = await _supabaseClient
          .rpc('undo_last_score', params: {'p_leg_id': currentLegId});
      if (response != null) {
        _undoScore(lastScore);
      }
    } catch (error) {
      errorMessage = 'Failed to undo last score: $error';
      print('Error undoing last score: $error');
    }
  }

  void _undoScore(int lastScore) {
    if (currentPlayerId == matchModel.player1Id) {
      currentScorePlayer1 += lastScore;
      lastFiveScoresPlayer1.removeLast();
    } else {
      currentScorePlayer2 += lastScore;
      lastFiveScoresPlayer2.removeLast();
    }
  }

  Future<void> _endCurrentLeg(String legWinnerId) async {
    try {
      legWins[legWinnerId] = (legWins[legWinnerId] ?? 0) + 1;
      await _updateLegWinner(legWinnerId);
      currentLegId = -1; // Reset currentLegId before creating a new leg
      if (legWins[legWinnerId] == matchModel.legTarget) {
        await _checkSetWinner(legWinnerId);
      } else {
        await _prepareForNextLeg(legWinnerId);
        await _startNewLeg();
      }
    } catch (error) {
      errorMessage = 'Failed to end current leg: $error';
      print('Error ending current leg: $error');
    }
  }

  Future<void> _prepareForNextLeg(String legWinnerId) async {
    // Alternate the starting player
    matchModel.startingPlayerId = matchModel.startingPlayerId == matchModel.player1Id
        ? matchModel.player2Id
        : matchModel.player1Id;

    // Update the starting player ID in the match table in the database
    await _supabaseClient.from('match').update({
      'starting_player_id': matchModel.startingPlayerId,
    }).eq('id', matchModel.id);

    // Set the current player to the new starting player for the next leg
    currentPlayerId = matchModel.startingPlayerId;

    currentScorePlayer1 = matchModel.startingScore;
    currentScorePlayer2 = matchModel.startingScore;
  }

  Future<void> _checkSetWinner(String setWinnerId) async {
    try {
      setWins[setWinnerId] = (setWins[setWinnerId] ?? 0) + 1;
      await _updateSetWinner(setWinnerId); // Update the set winner
      if (setWins[setWinnerId] == matchModel.setTarget) {
        await _updateMatchWinner(setWinnerId); // Update the match winner
        _endMatch(setWinnerId);
      } else {
        await _startNewSet();
      }
    } catch (error) {
      errorMessage = 'Failed to check set winner: $error';
      print('Error checking set winner: $error');
    }
  }

  Future<void> _updateSetWinner(String setWinnerId) async {
    try {
      await _supabaseClient
          .from('set')
          .update({'winner_id': setWinnerId}).eq('id', currentSetId);
    } catch (error) {
      errorMessage = 'Failed to update set winner: $error';
      print('Error updating set winner: $error');
    }
  }

  Future<void> _updateMatchWinner(String matchWinnerId) async {
    try {
      await _supabaseClient
          .from('match')
          .update({'winner_id': matchWinnerId}).eq('id', matchModel.id);
    } catch (error) {
      errorMessage = 'Failed to update match winner: $error';
      print('Error updating match winner: $error');
    }
  }

  void _endMatch(String matchWinnerId) {
    matchEnded = true;
    this.matchWinnerId = matchWinnerId;
    loadingMessage =
        "Match has ended. Winner: Player ${matchWinnerId == matchModel.player1Id ? 1 : 2}";
  }

  @action
  void updateTemporaryScore(String score) {
    temporaryScore = score;
  }

  void subscribeToScores() {
    _supabaseClient
        .from('turn')
        .stream(primaryKey: ['id'])
        .eq('leg_id', currentLegId)
        .order('id', ascending: true)
        .listen((data) {
          currentLegScores = ObservableList.of(data);
          _restoreLatestScores();
        })
        .onError((error) {
          errorMessage = 'Failed to subscribe to scores: $error';
          print('Error subscribing to scores: $error');
        });
  }
}
