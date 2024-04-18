import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MatchListWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5, // Replace 5 with the actual number of matches
      itemBuilder: (context, index) {
        final matchId = index + 1; // Assuming match IDs start from 1
        return Padding(
          padding: const EdgeInsets.symmetric(
              vertical: 4.0,
              horizontal: 16.0), // Adjust vertical and horizontal padding
          child: ElevatedButton(
            onPressed: () {
              context.go('/matches/$matchId');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  const Color(0xFFCD0612), // Set button color to red
              foregroundColor: Colors.white, // Set text color to white
              padding: EdgeInsets.symmetric(
                  vertical: 8, horizontal: 12), // Adjust button padding
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // Adjust button shape
              ),
            ),
            child: Text('Match $matchId',
                style: TextStyle(fontSize: 14)), // Set button text
          ),
        );
      },
    );
  }
}
