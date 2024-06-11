import 'dart:async';
import 'package:darts_application/features/auth/auth_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_auth_ui/supabase_auth_ui.dart';

import 'mocks.mocks.dart';

void main() {
  const MethodChannel appLinksChannel =
      MethodChannel('com.llfbandit.app_links/messages');

  late MockSupabaseClient mockSupabaseClient;
  late MockGoTrueClient mockSupabaseAuthClient;
  late MockClient mockHttpClient;
  late StreamController<AuthState> authStateStreamController;

  setUp(() {
    // Setup plugins used by Supabase
    SharedPreferences.setMockInitialValues({});
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(
      appLinksChannel,
      (MethodCall methodCall) async {
        switch (methodCall.method) {
          case 'getInitialAppLink':
            return null; // Return a mock initial app link if needed
          default:
            return null;
        }
      },
    );

    // Setup Supabase mock
    authStateStreamController = StreamController<AuthState>();
    mockHttpClient = MockClient();
    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseAuthClient = MockGoTrueClient();

    // Return mockSupabaseAuthClient when accessing mockSupabaseClient.auth
    when(mockSupabaseClient.auth).thenReturn(mockSupabaseAuthClient);

    // Return authStateControllers stream for onAuthStateChange
    when(mockSupabaseAuthClient.onAuthStateChange)
        .thenAnswer((_) => authStateStreamController.stream);

    // Replace actual Supabase client with the mock
    Supabase.initialize(
      anonKey: '',
      url: '',
      httpClient: mockHttpClient,
    );
    Supabase.instance.client = mockSupabaseClient;
  });

  tearDown(() {
    clearInteractions(mockSupabaseClient);
    clearInteractions(mockSupabaseAuthClient);
    clearInteractions(mockHttpClient);
    authStateStreamController.close();
    Supabase.instance.dispose();
  });

  group('SignIn validations', () {
    testWidgets('Error messages on empty fields submitted',
        (WidgetTester tester) async {
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder signInButtonFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.signIn),
        matching: find.byType(ElevatedButton),
      );

      // Tap sign in with empty fields
      await tester.tap(signInButtonFinder);

      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for validation to take place

      expect(find.text(supaEmailAuth.localization.validEmailError), findsOne);
      expect(
          find.text(supaEmailAuth.localization.passwordLengthError), findsOne);
    });

    testWidgets('Error message on faulty email address',
        (WidgetTester tester) async {
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder emailFieldFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterEmail),
        matching: find.byType(TextFormField),
      );

      Finder signInButtonFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.signIn),
        matching: find.byType(ElevatedButton),
      );

      // Tap sign in with wrong email format
      await tester.enterText(emailFieldFinder, 'test@te');
      await tester.tap(signInButtonFinder);

      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for validation to take place

      expect(find.text(supaEmailAuth.localization.validEmailError), findsOne);
    });

    testWidgets('Error message on faulty password',
        (WidgetTester tester) async {
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder passwordFieldFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterPassword),
        matching: find.byType(TextFormField),
      );

      Finder signInButtonFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.signIn),
        matching: find.byType(ElevatedButton),
      );

      // Tap sign in with wrong password format
      await tester.enterText(
          passwordFieldFinder, 'pass'); // shorter than 6 characters
      await tester.tap(signInButtonFinder);

      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for validation to take place

      expect(
          find.text(supaEmailAuth.localization.passwordLengthError), findsOne);
    });

    testWidgets('SignIn gets called when validation passes',
        (WidgetTester tester) async {
      String email = 'john.doe@example.com';
      String password = 'SomeSecretSauce!23';
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder emailFieldFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterEmail),
        matching: find.byType(TextFormField),
      );

      Finder passwordFieldFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterPassword),
        matching: find.byType(TextFormField),
      );

      Finder signInButtonFinder = find.ancestor(
        of: find.text(supaEmailAuth.localization.signIn),
        matching: find.byType(ElevatedButton),
      );

      // Tap sign in with correct values
      await tester.enterText(emailFieldFinder, email);
      await tester.enterText(passwordFieldFinder, password);

      await tester.tap(signInButtonFinder);
      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for validation to take place

      verify(
        mockSupabaseAuthClient.signInWithPassword(
          email: email,
          password: password,
        ),
      ).called(1);

      expect(
          find.text(supaEmailAuth.localization.validEmailError), findsNothing);
      expect(find.text(supaEmailAuth.localization.passwordLengthError),
          findsNothing);
    });
  });
}
