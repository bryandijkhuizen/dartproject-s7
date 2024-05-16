import 'package:darts_application/models/match.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/models/match_statistics.dart';
import 'package:darts_application/models/set.dart';
import 'package:darts_application/models/leg.dart';
import 'package:darts_application/models/turn.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchStatisticsWidget extends StatefulWidget {
  const MatchStatisticsWidget({super.key});

  @override
  State<MatchStatisticsWidget> createState() => _MatchStatisticsWidgetState();
}

class _MatchStatisticsWidgetState extends State<MatchStatisticsWidget> {
  late Future<MatchStatisticsModel> _matchStatisticsFuture;

  late List<int> setIds;
  late List<int> legIds;
  late List<TurnModel> turns;
  late String player1Id = "9b2b4f5e-e0d9-4f9b-bf9c-a5774fb12f8d";
  late String player2Id = "48cfd5f7-727f-478b-b808-03365c325567";

  @override
  void initState() {
    super.initState();
    _matchStatisticsFuture = fetchMatchStatistics();
  }

  Future<MatchStatisticsModel> fetchMatchStatistics() async {
    final setsResponse = await Supabase.instance.client
        .rpc('get_sets_by_match_id', params: {'current_match_id': 1});

    final setsData = setsResponse as List<dynamic>? ?? [];

    final List<int> setIds =
        setsData.map<int>((set) => set['id'] as int).toList();

    final List<int> legIds = [];
    for (final setId in setIds) {
      final legsResponse = await Supabase.instance.client
          .rpc('get_legs_by_set_id', params: {'current_set_id': setId});

      final legsData = legsResponse as List<dynamic>? ?? [];

      final List<int> legIdsForSet =
          legsData.map<int>((leg) => leg['id'] as int).toList();

      legIds.addAll(legIdsForSet);
    }
    late List<TurnModel> turns = [];

    for (final legId in legIds) {
      final turnsResponse = await Supabase.instance.client
          .rpc('get_turns_by_leg_id', params: {'current_leg_id': legId});

      final turnData = turnsResponse as List<dynamic>? ?? [];

      for (final turn in turnData) {
        turns.add(TurnModel(
          id: turn['id'] as int,
          playerId: turn['player_id'] as String,
          legId: turn['leg_id'] as int,
          score: turn['score'] as int,
          doubleAttempts: turn['double_attempts'] as int? ?? 0,
          doubleHits: turn['double_hits'] as int? ?? 0,
          isDeadThrow: turn['is_dead_throw'] as bool,
        ));
      }
    }

    return MatchStatisticsModel(turns: turns);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<MatchStatisticsModel>(
      future: _matchStatisticsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          return Center(
            child: Text('Failed to load match statistics: ${snapshot.error}'),
          );
        }

        final matchStatistics = snapshot.data!;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16.0),
              child: Text(
                'Match Statistics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.75,
              child: const Divider(),
            ),
            // Add your widgets to display match statistics here
            Text(
                'Player 1 Average Score: ${matchStatistics.calculateAverageScore(player1Id)}'),
            Text(
                'Player 2 Average Score: ${matchStatistics.calculateAverageScore(player2Id)}'),
          ],
        );
      },
    );
  }
}
