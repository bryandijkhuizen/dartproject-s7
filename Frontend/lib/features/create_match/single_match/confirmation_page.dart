import 'package:flutter/material.dart';
import 'package:darts_application/models/match.dart';

class ConfirmationPage extends StatelessWidget {
  final MatchModel match;

  const ConfirmationPage({
    super.key,
    required this.match,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match Confirmation'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('✅ Match created!', style: TextStyle(fontSize: 28)),
            const SizedBox(height: 20),
            const Text('Match details', style: TextStyle(fontSize: 22)),
            const SizedBox(height: 20),
            Text('Player One: ${match.player1LastName}', style: const TextStyle(fontSize: 16)),
            Text('Player Two: ${match.player2LastName}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(match.location ?? 'Unknown location', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Date and time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${match.date.toLocal()}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Match Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(match.startingScore.toString(), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Number of Legs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(match.legTarget.toString(), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Number of Sets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(match.setTarget.toString(), style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
