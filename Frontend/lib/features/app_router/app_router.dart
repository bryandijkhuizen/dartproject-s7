import 'package:darts_application/components/scaffolding.dart';
import 'package:darts_application/features/app_router/app_router_redirect.dart';
import 'package:darts_application/features/auth/auth_notifier.dart';
import 'package:darts_application/features/auth/auth_view.dart';
import 'package:darts_application/features/settings/views/settings_email_view.dart';
import 'package:darts_application/features/settings/views/settings_name_view.dart';
import 'package:darts_application/features/settings/views/settings_password_view.dart';
import 'package:darts_application/features/settings/views/settings_view.dart';
import 'package:darts_application/helpers.dart';
import 'package:darts_application/features/gameplay//views/match_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/features/setup_match/start_match.dart';
import 'package:darts_application/features/setup_match/views/match_list_widget.dart';
import 'package:darts_application/features/statistics/views/match_statistics_widget.dart';

Widget getPlaceholderComponent(
    String currentRoute, List<String> routes, BuildContext context) {
  return Center(
    child: Column(
      children: [
        Text('Current route: $currentRoute'),
        for (String route in routes)
          TextButton(
            onPressed: () {
              context.go(route);
            },
            child: Text('Go to $route'),
          ),
        TextButton(
            onPressed: () {
              Supabase.instance.client.auth.signOut();
            },
            child: const Text('Sign out')),
      ],
    ),
  );
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// SettingsRoute is identical on mobile and desktop
final settingsRoute = StatefulShellBranch(
  routes: <RouteBase>[
    GoRoute(
      path: '/settings',
      builder: (context, state) {
        return const SettingsView();
      },
      routes: <RouteBase>[
        GoRoute(
          path: 'name',
          builder: (context, state) => const SettingsNameView(),
        ),
        GoRoute(
          path: 'email',
          builder: (context, state) => const SettingsEmailView(),
        ),
        GoRoute(
          path: 'password',
          builder: (context, state) => const SettingsPasswordView(),
        )
      ],
    ),
  ],
);

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/auth',
  refreshListenable: AuthNotifier(),
  redirect: appRouterRedirect,
  routes: <RouteBase>[
    // Auth route
    GoRoute(
      path: '/auth',
      builder: (context, state) {
        return const AuthView();
      },
    ),

    // App routes (After authentication)
    StatefulShellRoute.indexedStack(
      // Builder for the scaffold including the bottomNavbar
      builder: (context, state, navigationShell) {
        return Scaffolding(shell: navigationShell);
      },
      branches: isMobile
          // Mobile branches
          ? <StatefulShellBranch>[
              // Mobile homepage branch
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/',
                          ['/statistics', '/matches', '/settings', '/gameplay'],
                          context);
                    },
                  ),
                ],
              ),

              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/gameplay',
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':matchId',
                        builder: (context, state) {
                          final matchId = state.pathParameters['matchId']!;
                          return MatchView(matchId: matchId);
                        },
                      ),
                    ],
                    // ignore: prefer_const_constructors
                    builder: (context, state) => MatchView(
                      matchId: '1',
                    ),
                  ),
                ],
              ),

              // Mobile statistics
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/statistics',
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':matchId',
                        builder: (context, state) {
                          final matchId = state.pathParameters['matchId']!;
                          return MatchStatisticsWidget(matchId: matchId);
                        },
                      ),
                    ],
                    builder: (context, state) {
                      return const MatchStatisticsWidget(matchId: '1');
                    },
                  ),
                ],
              ),

              // Mobile matches route
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/matches',
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':matchId',
                        builder: (context, state) {
                          final matchId = state.pathParameters['matchId']!;
                          return StartMatch(matchId: matchId);
                        },
                      ),
                    ],
                    builder: (context, state) {
                      return const MatchListWidget();
                    },
                  ),
                ],
              ),

              // Mobile user settings
              settingsRoute,
            ]
          // Desktop branches
          : [
              // Desktop Home
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/',
                          ['/statistics', '/matches', '/settings', '/gameplay'],
                          context);
                    },
                  ),
                ],
              ),

              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/gameplay',
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':matchId',
                        builder: (context, state) {
                          final matchId = state.pathParameters['matchId']!;
                          return MatchView(matchId: matchId);
                        },
                      ),
                    ],
                    // ignore: prefer_const_constructors
                    builder: (context, state) => MatchView(
                      matchId: '1',
                    ),
                  ),
                ],
              ),
              // Desktop statistics
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/statistics',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/statistics',
                          [
                            '/',
                            '/matches',
                            '/settings',
                          ],
                          context);
                    },
                  ),
                ],
              ),

              // Desktop statistics
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/matches',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/matches',
                          [
                            '/',
                            '/matches',
                            '/settings',
                          ],
                          context);
                    },
                  ),
                ],
              ),

              // Branch for user management
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/user-management',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/user-management',
                          [
                            '/',
                            '/statistics',
                            '/matches',
                          ],
                          context);
                    },
                  ),
                ],
              ),

              // Branch for club management (Supported platforms: Desktop)
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/club-management',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/club-management',
                          [
                            '/',
                            '/statistics',
                            '/matches',
                          ],
                          context);
                    },
                  ),
                ],
              ),

              settingsRoute
            ],
    ),
  ],
);
