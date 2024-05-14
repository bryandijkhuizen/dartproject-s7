import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/exceptions/dart_game_exception.dart';

part 'match_store.g.dart';

// ignore: library_private_types_in_public_api
class MatchStore = _MatchStore with _$MatchStore;

abstract class _MatchStore with Store {
  final SupabaseClient _supabaseClient;
  final String matchId;
  late final MatchModel matchModel;
  bool isFirstLeg = true;  // Flag to check if it's the first leg of the match

  @observable
  bool setupComplete = false;

  _MatchStore(this._supabaseClient, this.matchId) {
    _init();
  }

  @observable
  ObservableList<int> lastFiveScoresPlayer1 = ObservableList<int>();

  @observable
  ObservableList<int> lastFiveScoresPlayer2 = ObservableList<int>();

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

  Future<void> _init() async {
    if (setupComplete) return;

    isLoading = true;
    loadingMessage = 'Initializing match details...';
    try {
      final response = await _supabaseClient
          .from('match')
          .select('*')
          .eq('id', matchId)
          .single();

      matchModel = MatchModel.fromJson(response);

      final player1Response = await _supabaseClient
          .from('user')
          .select('last_name')
          .eq('id', matchModel.player1Id)
          .single();
      matchModel.player1LastName = player1Response['last_name'] ?? 'Unknown';

      final player2Response = await _supabaseClient
          .from('user')
          .select('last_name')
          .eq('id', matchModel.player2Id)
          .single();
      matchModel.player2LastName = player2Response['last_name'] ?? 'Unknown';

      currentScorePlayer1 = matchModel.startingScore;
      currentScorePlayer2 = matchModel.startingScore;

      currentPlayerId = matchModel.startingPlayerId;

      await _checkForActiveSetOrCreateNew();
      subscribeToScores();
      isLoading = false;

      setupComplete = true;
    } catch (error) {
      errorMessage = 'Initialization failed: $error';
      isLoading = false;
    }
  }

  Future<void> _checkForActiveSetOrCreateNew() async {
    try {
      final response = await _supabaseClient
          .from('set')
          .select('*')
          .eq('match_id', matchModel.id)
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null || response['winner_id'] != null) {
        await _startNewSet();
      } else {
        currentSetId = response['id'];
        await _checkForActiveLegOrCreateNew();
      }
    } catch (error) {
      errorMessage = 'Failed to check for active set or create new: $error';
    }
  }

  Future<void> _checkForActiveLegOrCreateNew() async {
    try {
      final response = await _supabaseClient
          .from('leg')
          .select('*')
          .eq('set_id', currentSetId)
          .order('id', ascending: false)
          .limit(1)
          .maybeSingle();

      if (response == null || response['winner_id'] != null) {
        await _startNewLeg();
      } else {
        currentLegId = response['id'];
        final turnResponse = await _supabaseClient
            .from('turn')
            .select('current_score, current_score2')
            .eq('leg_id', currentLegId)
            .order('id', ascending: false)
            .limit(1)
            .maybeSingle();
        if (turnResponse != null) {
          currentScorePlayer1 = turnResponse['current_score'];
          currentScorePlayer2 = turnResponse['current_score2'];
        }
      }
    } catch (error) {
      errorMessage = 'Failed to check for active leg or create new: $error';
    }
  }

  Future<void> _startNewSet() async {
    isLoading = true;
    loadingMessage = 'Starting new set...';
    try {
      final response = await _supabaseClient
          .rpc('create_set', params: {'match_id': matchModel.id});
      currentSetId = response[0]['set_id'];
      await _startNewLeg();
      isLoading = false;
    } catch (e) {
      errorMessage = 'Failed to start a new set: $e';
      isLoading = false;
    }
  }

  Future<void> _startNewLeg() async {
    isLoading = true;
    loadingMessage = 'Starting new leg...';
    try {
      final response = await _supabaseClient
          .rpc('create_leg', params: {'set_id': currentSetId});
      currentLegId = response[0]['leg_id'];

      if (isFirstLeg) {
        currentPlayerId = matchModel.startingPlayerId;
        isFirstLeg = false;
      } else {
        currentPlayerId = currentPlayerId == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
      }

      currentScorePlayer1 = matchModel.startingScore;
      currentScorePlayer2 = matchModel.startingScore;

      lastFiveScoresPlayer1.clear();
      lastFiveScoresPlayer2.clear();

      isLoading = false;
    } catch (e) {
      errorMessage = 'Failed to start a new leg: $e';
      isLoading = false;
    }
  }

  @action
  Future<void> recordScore(int score) async {
    try {
      if (score < 0 || score > 180) {
        throw DartGameException('Invalid score: $score');
      }

      final response = await _supabaseClient.rpc('record_turn', params: {
        'player_id': currentPlayerId,
        'new_leg_id': currentLegId,
        'score': score
      });

      final legWinnerId = response[0]['leg_winner_id'];
      final newScore = response[0]['new_score'];
      final newScore2 = response[0]['new_score2'];

      if (currentPlayerId == matchModel.player1Id) {
        currentScorePlayer1 = newScore is int ? newScore : int.parse(newScore);
        lastFiveScoresPlayer1.add(score);
        if (lastFiveScoresPlayer1.length > 5) {
          lastFiveScoresPlayer1.removeAt(0);
        }
      } else {
        currentScorePlayer2 =
            newScore2 is int ? newScore2 : int.parse(newScore2);
        lastFiveScoresPlayer2.add(score);
        if (lastFiveScoresPlayer2.length > 5) {
          lastFiveScoresPlayer2.removeAt(0);
        }
      }

      if (legWinnerId != null) {
        await _updateLegWinner(legWinnerId.toString());
        await endCurrentLeg(legWinnerId.toString());
      } else {
        currentPlayerId = currentPlayerId == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
      }

      updateTemporaryScore('');
    } catch (e) {
      errorMessage = 'Failed to record score: $e';
    }
  }

  Future<void> _updateLegWinner(String legWinnerId) async {
    try {
      await _supabaseClient
          .from('leg')
          .update({'winner_id': legWinnerId}).eq('id', currentLegId);
    } catch (e) {
      errorMessage = 'Failed to update leg winner: $e';
    }
  }

  @action
  Future<void> undoLastScore() async {
    try {
      final lastScore = currentPlayerId == matchModel.player1Id
          ? (lastFiveScoresPlayer1.isNotEmpty ? lastFiveScoresPlayer1.last : 0)
          : (lastFiveScoresPlayer2.isNotEmpty ? lastFiveScoresPlayer2.last : 0);

      final response = await _supabaseClient
          .rpc('undo_last_score', params: {'leg_id': currentLegId});
      if (response != null) {
        if (currentPlayerId == matchModel.player1Id) {
          currentScorePlayer1 += lastScore;
          lastFiveScoresPlayer1.removeLast();
        } else {
          currentScorePlayer2 += lastScore;
          lastFiveScoresPlayer2.removeLast();
        }
      }
    } catch (e) {
      errorMessage = 'Failed to undo last score: $e';
    }
  }

  @action
  Future<void> endCurrentLeg(String legWinnerId) async {
    try {
      legWins[legWinnerId] = (legWins[legWinnerId] ?? 0) + 1;
      await _updateLegWinner(legWinnerId);
      if (legWins[legWinnerId] == matchModel.legTarget) {
        await checkSetWinner(legWinnerId);
      } else {
        currentPlayerId = legWinnerId == matchModel.player1Id
            ? matchModel.player2Id
            : matchModel.player1Id;
        currentScorePlayer1 = matchModel.startingScore;
        currentScorePlayer2 = matchModel.startingScore;
        await _startNewLeg();
      }
    } catch (e) {
      errorMessage = 'Failed to end current leg: $e';
    }
  }

  @action
  Future<void> checkSetWinner(String setWinnerId) async {
    try {
      setWins[setWinnerId] = (setWins[setWinnerId] ?? 0) + 1;
      if (setWins[setWinnerId] == matchModel.setTarget) {
        matchWinnerId = setWinnerId;
        endMatch();
      } else {
        await _startNewSet();
      }
    } catch (e) {
      errorMessage = 'Failed to check set winner: $e';
    }
  }

  @action
  void endMatch() {
    matchEnded = true;
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
        })
        .onError((error) {
          errorMessage = 'Failed to subscribe to scores: $error';
        });
  }
}

