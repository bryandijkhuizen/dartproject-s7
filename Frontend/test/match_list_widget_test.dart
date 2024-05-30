import 'package:darts_application/features/setup_match/match_list.dart';
import 'package:darts_application/models/match.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'mock_supabase.mocks.dart';

void main() {
  group('Match list tests', () {
    final List<MatchModel> testMatches = [
      MatchModel(
        id: '1',
        player1Id: '1',
        player2Id: '2',
        date: DateTime.now(),
        setTarget: 3,
        legTarget: 3,
        startingScore: 501,
        player1LastName: 'Doe',
        player2LastName: 'Smith',
      ),
      MatchModel(
        id: '2',
        player1Id: '1',
        player2Id: '2',
        date: DateTime.now(),
        setTarget: 3,
        legTarget: 3,
        startingScore: 501,
        player1LastName: 'Smith',
        player2LastName: 'Doe',
      ),
    ];

    late MockSupabaseClient mockSupabaseClient;

    setUp(() {
      mockSupabaseClient = MockSupabaseClient();
      Supabase.initialize(
          url: 'http://127.0.0.1:54321',
          anonKey:
              'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZS1kZW1vIiwicm9sZSI6ImFub24iLCJleHAiOjE5ODM4MTI5OTZ9.CRXP1A7WOeoJeXxjNni43kdQwgnWNReilDMblYTn_Ic');
      Supabase.instance.client = mockSupabaseClient;
    });

    testWidgets('Match list displays correct matches',
        (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MatchList(
            matches: testMatches,
            title: 'Matches',
          ),
        ),
      ));

      expect(find.text('Matches'), findsOneWidget);

      expect(find.textContaining('Match 1: Doe vs Smith'), findsOneWidget);
      expect(find.textContaining('Match 2: Smith vs Doe'), findsOneWidget);
    });
  });
}
