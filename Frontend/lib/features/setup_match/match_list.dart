// ignore_for_file: use_super_parameters, use_build_context_synchronously

import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/features/setup_match/stores/match_setup_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';

class MatchList extends StatelessWidget {
  final List<MatchModel> matches;
  final String title;

  MatchList({
    Key? key,
    required this.matches,
    required this.title,
  }) : super(key: key);

  final MatchSetupStore matchSetupStore = MatchSetupStore(
      Supabase.instance.client, UserStore(Supabase.instance.client));

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        bool isDesktop = constraints.maxWidth > 600;
        double buttonWidth = isDesktop
            ? constraints.maxWidth * 0.5
            : constraints.maxWidth * 0.75;

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
              width: buttonWidth,
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
                  ),
                  child: Center(
                    child: Container(
                      width: buttonWidth,
                      child: ElevatedButton(
                        onPressed: () async {
                          if (await matchSetupStore.matchAlreadyStarted(
                              matches, matchId)) {
                            router.push('/gameplay/$matchId');
                          } else {
                            router.push('/matches/$matchId');
                          }
                        },
                        style: ElevatedButton.styleFrom(
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
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }
}
