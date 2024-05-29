import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:darts_application/features/create_tournament/create_tournament_page.dart';

void main() {
  group('Tournament creation tests', () {
    testWidgets('Form shows validation error when name is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTournamentPage()));

      // Ensure the "Create tournament" button is visible
      await tester.ensureVisible(find.text('Create tournament'));

      // Leave the name field empty and click the create tournament button
      await tester.tap(find.text('Create tournament'));
      await tester.pump();

      // Check if validation error is shown
      expect(find.text('Please enter a name'), findsOneWidget);
    });

    testWidgets('Form shows validation error when location is empty', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTournamentPage()));

      // Ensure the "Create tournament" button is visible
      await tester.ensureVisible(find.text('Create tournament'));

      // Leave the location field empty and click the create tournament button
      await tester.tap(find.text('Create tournament'));
      await tester.pump();

      // Check if validation error is shown
      expect(find.text('Please enter a location'), findsOneWidget);
    });

    testWidgets('Updates name field on user input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTournamentPage()));

      // Enter the tournament name
      await tester.enterText(find.byType(TextFormField).at(0), 'Het Grootste Toernooi');
      await tester.pump();

      // Verify if the name field is updated
      expect(find.text('Het Grootste Toernooi'), findsOneWidget);
    });

    testWidgets('Updates location field on user input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTournamentPage()));

      // Enter the tournament location
      await tester.enterText(find.byType(TextFormField).at(1), 'Leeuwarden');
      await tester.pump();

      // Verify if the location field is updated
      expect(find.text('Leeuwarden'), findsOneWidget);
    });

    testWidgets('Updates starting method state on user input', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: CreateTournamentPage()));

      // Select random starting method
      await tester.tap(find.byType(Checkbox).at(1));
      await tester.pump();

      // Verify if the starting method state is updated
      expect(find.byType(Checkbox).at(0).evaluate().single.widget, isA<Checkbox>().having((c) => c.value, 'value', false));
      expect(find.byType(Checkbox).at(1).evaluate().single.widget, isA<Checkbox>().having((c) => c.value, 'value', true));
    });
  });
}
