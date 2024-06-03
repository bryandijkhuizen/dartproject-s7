import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String matchTitle;

  const MatchCard({super.key, required this.matchTitle});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(matchTitle),
      ),
    );
  }
}
