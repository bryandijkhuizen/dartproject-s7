import 'package:flutter/material.dart';
import 'package:darts_application/features/club_page/widgets/score_card.dart';

class RecentScoresView extends StatelessWidget {
  const RecentScoresView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Text('Recent Scores'),
        ScoreCard(scoreDetails: 'Player A vs Player B: 3-2'),
        SizedBox(height: 20),
        ScoreCard(scoreDetails: 'Player C vs Player D: 1-3'),
      ],
    );
  }
}
