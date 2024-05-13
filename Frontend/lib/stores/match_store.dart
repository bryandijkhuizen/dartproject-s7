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

  _MatchStore(this._supabaseClient, this.matchId) {
    _init().catchError((error) {
      throw DartGameException('Failed to initialize MatchStore: $error');
    });
  }

  @observable
  ObservableList<int> lastFiveScores = ObservableList<int>();

  @observable
  ObservableList<Map<String, dynamic>> currentLegScores =
      ObservableList<Map<String, dynamic>>();

  @observable
  int currentLegId = -1;

  @observable
  int currentSetId = -1;

  @observable
  Map<int, int> legWins = {};

  @observable
  Map<int, int> setWins = {};

  @observable
  late int currentScore;

  @observable
  late int currentPlayerId;

  @observable
  int? matchWinnerId;

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
    isLoading = true;
    loadingMessage = 'Initializing match details...';
    try {
      final response = await _supabaseClient
          .from('match')
          .select('*')
          .eq('id', matchId)
          .single();

      matchModel = MatchModel.fromJson(response);
      currentScore = int.tryParse(matchModel.startingScore.toString()) ?? 0;
      currentPlayerId =
          int.tryParse(matchModel.startingPlayerId ?? matchModel.player1Id) ??
              0;
      
      await _startNewSet();
      subscribeToScores();
      isLoading = false;
    } catch (error) {
      errorMessage = 'Initialization failed: $error';
      isLoading = false;
    }
  }

  Future<void> _startNewSet() async {
    isLoading = true;
    loadingMessage = 'Starting new set...';
    try {
      final response = await _supabaseClient
          .rpc('create_set', params: {'match_id': matchModel.id});
      currentSetId = response[0]['set_id'];
      print("set created");
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
      currentLegId = int.parse(response['id'].toString());
      print("leg created");
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
        'leg_id': currentLegId,
        'score': score
      });

      currentScore -= score;
      lastFiveScores.add(score);
      if (lastFiveScores.length > 5) {
        lastFiveScores.removeAt(0);
      }
      if (response.data['leg_winner_id'] != null) {
        await endCurrentLeg(response.data['leg_winner_id']);
      }
    } catch (e) {
      errorMessage = 'Failed to record score: $e';
    }
  }

  @action
  Future<void> undoLastScore() async {
    try {
      final lastScore = lastFiveScores.isNotEmpty ? lastFiveScores.last : 0;
      final response = await _supabaseClient
          .rpc('undo_last_score', params: {'leg_id': currentLegId});
      if (response.data != null) {
        currentScore += lastScore;
        lastFiveScores.removeLast();
      }
    } catch (e) {
      errorMessage = 'Failed to undo last score: $e';
    }
  }

  @action
  Future<void> endCurrentLeg(int legWinnerId) async {
    try {
      legWins[legWinnerId] = (legWins[legWinnerId] ?? 0) + 1;
      if (legWins[legWinnerId] == matchModel.legTarget) {
        await checkSetWinner(legWinnerId);
      } else {
        currentPlayerId = currentPlayerId == int.parse(matchModel.player1Id)
            ? int.parse(matchModel.player2Id)
            : int.parse(matchModel.player1Id);
        currentScore = matchModel.startingScore;
        await _startNewLeg();
      }
    } catch (e) {
      errorMessage = 'Failed to end current leg: $e';
    }
  }

  @action
  Future<void> checkSetWinner(int setWinnerId) async {
    try {
      setWins[setWinnerId] = (setWins[setWinnerId] ?? 0) + 1;
      if (setWins[setWinnerId] == matchModel.setTarget) {
        matchWinnerId = setWinnerId;
        // End match logic here
      } else {
        await _startNewSet();
      }
    } catch (e) {
      errorMessage = 'Failed to check set winner: $e';
    }
  }

  @action
  void endMatch() {
    if (matchWinnerId != null) {
      matchEnded = true;
      loadingMessage =
          "Match has ended. Winner: Player ${matchWinnerId == matchModel.player1Id ? 1 : 2}";
    }
  }

  @action
  void updateTemporaryScore(String score) {
    temporaryScore = score;
  }

  void subscribeToScores() {
    print("kaasje");
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
