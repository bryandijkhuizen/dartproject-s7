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

  bool isValidMatchId(String matchId) {
    return RegExp(r'^\d+$').hasMatch(matchId);
  }

  Future<Map<String, dynamic>?> getMatchDetails(String matchId) async {
    if (!isValidMatchId(matchId)) {
      throw DartGameException('Invalid or empty match ID');
    }
    try {
      final response =
          await client.rpc('get_match_details', params: {'match_id': matchId});
      if (response.isNotEmpty) {
        return response[0] as Map<String, dynamic>;
      } else {
        print("No data returned from getMatchDetails.");
        throw DartGameException('No match details found');
      }
    } catch (error) {
      print('Error in getMatchDetails: $error');
      throw DartGameException(
          'Failed to fetch match details: ${error.toString()}');
    }
  }

  Stream<List<Map<String, dynamic>>> subscribeToMatchChanges(String matchId) {
    if (!isValidMatchId(matchId)) {
      throw DartGameException('Invalid match ID');
    }
    return client.from('match').stream(primaryKey: ['id']).eq('id', matchId);
  }

  Stream<List<Map<String, dynamic>>> subscribeToTurnChanges(String matchId) {
    if (!isValidMatchId(matchId)) {
      throw DartGameException('Invalid match ID');
    }
    try {
      return client
          .rpc('get_turns_for_match', params: {'input_match_id': matchId})
          .asStream()
          .map((data) {
        if (data == null || data.isEmpty) {
          throw DartGameException('No turn data available.');
        }
        return List<Map<String, dynamic>>.from(
            data.map((item) => Map<String, dynamic>.from(item)));
      });
    } catch (e) {
      print('Error subscribing to turn changes: $e');
      throw DartGameException(
          'Error subscribing to turn changes: ${e.toString()}');
    }
  }

  Future<Map<String, int>> getCurrentLegStand(String matchId) async {
    try {
      final response =
          await client.rpc('get_current_leg_stand', params: {'match_id': matchId});

      Map<String, int> legStand = {};
      for (var row in response) {
        legStand[row['winner_id'].toString()] = row['count'];
      }
      return legStand;
    } catch (e) {
      print('Error fetching leg stand: $e');
      throw DartGameException('Error fetching leg stand: ${e.toString()}');
    }
  }

  Future<Map<String, int>> getCurrentSetStand(String matchId) async {
    try {
      final response =
          await client.rpc('get_current_set_stand', params: {'match_id': matchId});
      Map<String, int> setStand = {};
      for (var row in response) {
        if (row.error != null) {
          throw DartGameException('Failed to fetch set stand: ${row.error.message}');
        }
        setStand[row['winner_id'].toString()] = row['count'];
      }
      return setStand;
    } catch (e) {
      throw DartGameException('Error fetching set stand: ${e.toString()}');
    }
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
    try {
      print(legId);
      final response = await client.rpc('enter_score', params: {
        'leg_id': legId,
        'player_id': playerId,
        'score': score,
      });
      if (response.error != null) {
        throw DartGameException(
            'Failed to enter score: ${response.error.message}');
      }
    } catch (error) {
      throw DartGameException('Failed to enter score: $error');
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
          'Failed to undo last score: ${response.error.message}');
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

  Future<Map<String, dynamic>> getEndOfMatchResult(String matchId) async {
    try {
      final response =
          await client.rpc('get_end_of_match_result', params: {'match_id': matchId});
      if (response.error != null) {
        throw DartGameException('Failed to fetch end of match result: ${response.error.message}');
      }
      return response.data[0] as Map<String, dynamic>;
    } catch (e) {
      throw DartGameException('Failed to fetch end of match result: $e');
    }
  }
}
