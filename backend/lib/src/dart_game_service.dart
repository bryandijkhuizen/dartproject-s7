import 'package:supabase_flutter/supabase_flutter.dart';

class DartGameException implements Exception {
  final String message;
  DartGameException(this.message);

  @override
  String toString() => 'DartGameException: $message';
}

class DartGameService {
  final SupabaseClient client;

  DartGameService(this.client);

  // Validate the UUID before making the call
  Future<Map<String, dynamic>> getMatchDetails(String matchId) async {
    if (!isValidUUID(matchId)) {
      throw DartGameException('Invalid or empty match ID');
    }
    final response = await client.rpc('get_match_details', params: {'match_id': matchId});
    if (response.error != null) {
      throw DartGameException('Failed to fetch match details: ${response.error!.message}');
    }
    return response.data;
  }

  // Subscribe to match changes with validation
  Stream<List<Map<String, dynamic>>> subscribeToMatchChanges(String matchId) {
    if (!isValidUUID(matchId)) {
      throw DartGameException('Invalid match ID');
    }
    return client.from('match').stream(primaryKey: ['id']).eq('id', matchId);
  }

  // Subscribe to turns with validation
  Stream<List<Map<String, dynamic>>> subscribeToTurns(String matchId) {
    if (!isValidUUID(matchId)) {
      throw DartGameException('Invalid match ID');
    }
    return client.from('turn').stream(primaryKey: ['id']).eq('match_id', matchId);
  }

  // Handling score entering with improved error handling
  Future<void> enterScore({
    required String legId,
    required String playerId,
    required String scoreInput,
  }) async {
    if (!_isValidInput(scoreInput)) {
      throw DartGameException('Invalid score input');
    }

    final score = _parseScore(scoreInput);
    if (score > 180) {
      throw DartGameException('Score exceeds the maximum score per turn');
    }

    final response = await client.rpc('enter_score', params: {
      'leg_id': legId,
      'player_id': playerId,
      'score': score,
    });

    if (response.error != null) {
      throw DartGameException('Failed to enter score: ${response.error!.message}');
    }
  }

  // Handling undo last score with improved error handling
  Future<void> undoLastScore({
    required String legId,
    required String playerId,
  }) async {
    final response = await client.rpc('undo_last_score', params: {
      'leg_id': legId,
      'player_id': playerId,
    });

    if (response.error != null) {
      throw DartGameException('Failed to undo last score: ${response.error!.message}');
    }
  }

  // Helper methods
  int _parseScore(String input) {
    int multiplier = input.startsWith('T') ? 3 : input.startsWith('D') ? 2 : 1;
    String numberPart = input.replaceAll(RegExp(r'[TD]'), '');
    int? parsedNumber = int.tryParse(numberPart);
    if (parsedNumber == null || parsedNumber < 0 || parsedNumber > 60) {
      throw DartGameException('Invalid number part in score input');
    }
    return parsedNumber * multiplier;
  }

  bool _isValidInput(String input) {
    RegExp regex = RegExp(r'^[TD]?[1-9][0-9]?$');
    return regex.hasMatch(input) && _parseScore(input) <= 180;
  }

  // UUID validation
  bool isValidUUID(String uuid) {
    RegExp exp = RegExp(r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$');
    return exp.hasMatch(uuid);
  }
}
