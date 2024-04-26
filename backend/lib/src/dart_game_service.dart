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

  Future<Map<String, dynamic>> getMatchDetails(String matchId) async {
    final response = await client.from('match').select('''
        *, 
        player_1_id:user!public_match_player_1_id_fkey (id, first_name, last_name), 
        player_2_id:user!public_match_player_2_id_fkey (id, first_name, last_name),
        starting_player_id:user!public_match_starting_player_id_fkey (id, first_name, last_name),
        winner_id:user!public_match_winner_id_fkey (id, first_name, last_name)
      ''').eq('id', matchId).single();

    final data = response;
    final player1Data = data['player_1_id'];
    final player2Data = data['player_2_id'];
    data['player_1_name'] =
        player1Data['first_name'] + ' ' + player1Data['last_name'];
    data['player_2_name'] =
        player2Data['first_name'] + ' ' + player2Data['last_name'];
    return data;
  }

  Stream<List<Map<String, dynamic>>> subscribeToMatchChanges(String matchId) {
    return client.from('match').stream(primaryKey: ['id']).eq('id', matchId);
  }

  Stream<List<Map<String, dynamic>>> subscribeToTurns(String matchId) {
    return client
        .from('turn')
        .stream(primaryKey: ['id']).eq('match_id', matchId);
  }

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
      throw DartGameException(
          'Failed to enter score: ${response.error!.message}');
    }
  }

  Future<void> undoLastScore({
    required String legId,
    required String playerId,
  }) async {
    final response = await client.rpc('undo_last_score', params: {
      'leg_id': legId,
      'player_id': playerId,
    });

    if (response.error != null) {
      throw DartGameException(
          'Failed to undo last score: ${response.error!.message}');
    }
  }

  int _parseScore(String input) {
    int multiplier = input.startsWith('T')
        ? 3
        : input.startsWith('D')
            ? 2
            : 1;
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
}
