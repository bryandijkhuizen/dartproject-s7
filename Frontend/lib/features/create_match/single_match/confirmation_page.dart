import 'package:flutter/material.dart';

class ConfirmationPage extends StatelessWidget {
  final String location;
  final DateTime matchDateTime;
  final String playerOne;
  final String playerTwo;
  final int legAmount;
  final int setAmount;
  final bool is301Match;

  const ConfirmationPage({
    super.key,
    required this.location,
    required this.matchDateTime,
    required this.playerOne,
    required this.playerTwo,
    required this.legAmount,
    required this.setAmount,
    required this.is301Match,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Match'),
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
            Text('Player One: $playerOne', style: const TextStyle(fontSize: 16)),
            Text('Player Two: $playerTwo', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Location', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(location, style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Date and time', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${matchDateTime.toLocal()}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Match Type', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(is301Match ? '301' : '501', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Number of Legs', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(legAmount.toString(), style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 20),
            const Text('Number of Sets', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text(setAmount.toString(), style: const TextStyle(fontSize: 16)),
            // ElevatedButton(
            //   onPressed: () => Navigator.pop(context),
            //   child: Text('Back'),
            // ),
          ],
        ),
      ),
    );
  }
}
