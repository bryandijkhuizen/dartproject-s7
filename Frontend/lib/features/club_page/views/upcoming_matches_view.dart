import 'package:flutter/material.dart';
import 'package:darts_application/features/club_page/widgets/match_card.dart';

class UpcomingMatchesView extends StatelessWidget {
  const UpcomingMatchesView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Upcoming Matches'),
        MatchCard(matchTitle: 'Match 1'),
        SizedBox(height: 20),
        MatchCard(matchTitle: 'Match 2'),
      ],
    );
  }
}
