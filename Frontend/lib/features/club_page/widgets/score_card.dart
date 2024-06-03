import 'package:flutter/material.dart';

class ScoreCard extends StatelessWidget {
  final String scoreDetails;

  const ScoreCard({super.key, required this.scoreDetails});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(scoreDetails),
      ),
    );
  }
}
