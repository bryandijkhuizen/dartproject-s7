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
    // Setup plugins used by supabase
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

    try {
      Supabase.instance;
    } on AssertionError catch (_) {
      // No instance yet
      // Setup Supabase as 'initialized'
      Supabase.initialize(
        anonKey: '',
        url: '',
        httpClient: mockHttpClient,
      );
    }

    mockSupabaseClient = MockSupabaseClient();
    mockSupabaseAuthClient = MockGoTrueClient();
    // Return mockAuthClient when accessing mockSupabaseClient.auth
    when(mockSupabaseClient.auth).thenReturn(mockSupabaseAuthClient);
    // Return authStateControllers stream for onAuthStateChange
    when(mockSupabaseAuthClient.onAuthStateChange)
        .thenAnswer((_) => authStateStreamController.stream);

    // Replace actual Supabase client with the mock
    Supabase.instance.client = mockSupabaseClient;
  });

  group('AuthView Validation tests', () {
    group('Login validation', () {
      testWidgets('Sign in button exists', (WidgetTester tester) async {
        // Create AuthView
        await tester.pumpWidget(const MaterialApp(
          home: AuthView(),
        ));

        Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
        SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

        expect(
          find.ancestor(
            of: find.text(supaEmailAuth.localization.signIn),
            matching: find.byType(ElevatedButton),
          ),
          findsOneWidget,
        );
      });

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
        expect(find.text(supaEmailAuth.localization.passwordLengthError),
            findsOne);
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

        // Tap sign in with wrong email format
        await tester.enterText(
            passwordFieldFinder, 'pass'); // shorter than 6 characters :D
        await tester.tap(signInButtonFinder);

        await tester.pump(const Duration(
            milliseconds: 100)); // Wait for validation to take place

        expect(find.text(supaEmailAuth.localization.passwordLengthError),
            findsOne);
      });

      testWidgets('SignIn gets called when validation passes',
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

        // Tap sign in with wrong email format
        await tester.enterText(
            passwordFieldFinder, 'pass'); // shorter than 6 characters :D
        await tester.tap(signInButtonFinder);

        await tester.pump(const Duration(
            milliseconds: 100)); // Wait for validation to take place

        expect(find.text(supaEmailAuth.localization.passwordLengthError),
            findsOne);
      });
    });
  });

  group('Registration validation', () {
    testWidgets('First and last name are mandatory for sign up',
        (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder goToSignUpButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.dontHaveAccount),
        matching: find.byType(TextButton),
      );

      await tester.tap(goToSignUpButton);
      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for navigation to take place

      Finder firstNameField = find.ancestor(
        of: find.text("First name"),
        matching: find.byType(TextFormField),
      );

      Finder lastNameField = find.ancestor(
        of: find.text("Last name"),
        matching: find.byType(TextFormField),
      );

      expect(firstNameField, findsOneWidget);
      expect(lastNameField, findsOneWidget);

      Finder signUpButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.signUp),
        matching: find.byType(ElevatedButton),
      );

      await tester.tap(signUpButton);
      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for validation to take place

      expect(find.text('Please fill in your first name'), findsOneWidget);
      expect(find.text('Please fill in your last name'), findsOneWidget);
    });

    testWidgets('SignUp gets called when all fields are valid',
        (WidgetTester tester) async {
      String email = 'john@doe.com';
      String password = 'SomePassword!23';
      String firstName = 'John';
      String lastName = 'Doe';

      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);

      Finder goToSignUpButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.dontHaveAccount),
        matching: find.byType(TextButton),
      );

      await tester.tap(goToSignUpButton);
      await tester.pump(const Duration(
          milliseconds: 100)); // Wait for navigation to take place

      Finder emailField = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterEmail),
        matching: find.byType(TextFormField),
      );

      Finder passwordField = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterPassword),
        matching: find.byType(TextFormField),
      );

      Finder firstNameField = find.ancestor(
        of: find.text("First name"),
        matching: find.byType(TextFormField),
      );

      Finder lastNameField = find.ancestor(
        of: find.text("Last name"),
        matching: find.byType(TextFormField),
      );

      Finder signUpButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.signUp),
        matching: find.byType(ElevatedButton),
      );

      await tester.enterText(emailField, email);
      await tester.enterText(passwordField, password);
      await tester.enterText(firstNameField, firstName);
      await tester.enterText(lastNameField, lastName);

      await tester.tap(signUpButton);
      await tester.pump(
        const Duration(milliseconds: 100),
      ); // Wait for validation to take place

      verify(
        mockSupabaseAuthClient.signUp(
          email: email,
          password: password,
          data: {
            'first_name': firstName,
            'last_name': lastName,
          },
        ),
      ).called(1);

      expect(find.text('Please fill in your first name'), findsNothing);
      expect(find.text('Please fill in your last name'), findsNothing);
    });
  });
}
