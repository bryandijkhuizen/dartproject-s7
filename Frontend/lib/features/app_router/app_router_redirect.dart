import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

FutureOr<String?> appRouterRedirect(
    BuildContext context, GoRouterState goRouterState) async {
  // Get current user
  User? currentUser = Supabase.instance.client.auth.currentUser;

  final loggingOut =
      currentUser == null && goRouterState.matchedLocation == '/settings';
  final loggedIn = currentUser != null;
  final loggingIn = goRouterState.matchedLocation.startsWith('/auth');

  // Redirect to login page if no more user object while
  // user is on the settings page (clicked on logout button)
  if (loggingOut) return '/auth';
  // User is unauthorized to be in the application
  if (!loggedIn && !loggingIn) return '/auth';
  // If user logged in but still on auth page, redirect to homepage
  if (loggedIn && loggingIn) return '/';

  // No redirect
  return null;
}
