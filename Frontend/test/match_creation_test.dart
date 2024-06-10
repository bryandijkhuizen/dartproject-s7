import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darts_application/features/create_match/create_single_match_page.dart';

void main() {
  group('Match creation tests', () {
    testWidgets('Form shows validation error when field is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateSingleMatchPage()));

      // Click the create match button without entering location
      await tester.tap(find.text('Create match'));
      await tester.pump();

      // Check if validation error is shown
      expect(find.text('Please enter a location'), findsOneWidget);
    });

    testWidgets('Updates leg amount state on user input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateSingleMatchPage()));

      // Enter the leg amount
      await tester.enterText(find.byType(TextFormField).at(1), '3');
      await tester.pump();

      // Verify if the leg amount state is updated
      expect(find.text('3'), findsOneWidget);
    });
  });
}
