// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:darts_application/features/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';

class MatchList extends StatelessWidget {
  final List<MatchModel> matches;
  final String title;

  const MatchList({
    Key? key,
    required this.matches,
    required this.title,
  }) : super(key: key);

  Future<bool> matchAlreadyStarted(matchID) async {
    try {
      final response = await Supabase.instance.client
          .rpc('get_sets_by_match_id', params: {'current_match_id': matchID});

      final match = matches.where((match) => match.id == matchID).first;

      if (response.length > 0 && match.startingPlayerId != null) {
        return true;
      } else if (match.startingPlayerId != null && response.length <= 0) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      throw Exception('Failed to check if match already started: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Text(
            title,
            style: const TextStyle(
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
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: matches.length,
          itemBuilder: (context, index) {
            final match = matches[index];
            final matchId = match.id;
            final player1LastName = match.player1LastName;
            final player2LastName = match.player2LastName;

            return Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 4.0,
                horizontal: 16.0,
              ),
              child: ElevatedButton(
                onPressed: () async {
                  if (await matchAlreadyStarted(matchId)) {
                    router.push('/gameplay/$matchId');
                  } else {
                    router.push('/matches/$matchId');
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFCD0612),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  'Match $matchId: $player1LastName vs $player2LastName',
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow
                      .ellipsis, // Ensures text does not overflow the button boundary
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
