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

  group('Forgot password validation', () {
    testWidgets('Forgot password needs valid email',
        (WidgetTester tester) async {
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);
      Finder forgotPasswordButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.forgotPassword),
        matching: find.byType(TextButton),
      );

      await tester.tap(forgotPasswordButton);
      await tester.pumpAndSettle();

      Finder sendPasswordResetButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.sendPasswordReset),
        matching: find.byType(ElevatedButton),
      );

      await tester.tap(sendPasswordResetButton);
      await tester.pumpAndSettle();

      expect(find.text(supaEmailAuth.localization.validEmailError), findsOne);
    });
    testWidgets('Sends email using supabase api', (WidgetTester tester) async {
      String email = 'john.doe@example.com';
      // Create AuthView
      await tester.pumpWidget(const MaterialApp(
        home: AuthView(),
      ));

      Finder supaEmailAuthFinder = find.byType(SupaEmailAuth);
      SupaEmailAuth supaEmailAuth = tester.widget(supaEmailAuthFinder);
      Finder forgotPasswordButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.forgotPassword),
        matching: find.byType(TextButton),
      );

      await tester.tap(forgotPasswordButton);
      await tester.pumpAndSettle();

      Finder emailField = find.ancestor(
        of: find.text(supaEmailAuth.localization.enterEmail),
        matching: find.byType(TextFormField),
      );
      Finder sendPasswordResetButton = find.ancestor(
        of: find.text(supaEmailAuth.localization.sendPasswordReset),
        matching: find.byType(ElevatedButton),
      );

      await tester.enterText(emailField, email);
      await tester.tap(sendPasswordResetButton);
      await tester.pumpAndSettle();

      verify(
        mockSupabaseAuthClient.resetPasswordForEmail(
          email,
          redirectTo: supaEmailAuth.redirectTo,
        ),
      ).called(1);
    });
  });
}
