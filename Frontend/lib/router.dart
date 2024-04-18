import 'package:darts_application/components/scaffolding.dart';
import 'package:darts_application/helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'features/start_match/start_match.dart';
import 'features/start_match/match_list_widget.dart';

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
      ],
    ),
  );
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  redirect: (BuildContext context, GoRouterState state) {
    // TODO: Redirect user to login page when they're not signed in

    // TODO: Redirect user to homepage if they are logged in
    // (The user could go to /register or /login manually if we release a browser version)

    // TODO: Redirect user to previous page if they navigate to a page
    // on which they're not authorized

    // No redirect necessary
    return null;
  },
  routes: <RouteBase>[
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
                          [
                            '/statistics',
                            '/matches',
                            '/settings',
                          ],
                          context);
                    },
                  ),
                ],
              ),

              // Mobile statistics
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
                      return MatchListWidget();
                    },
                  ),
                ],
              ),

              // Mobile user settings
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/settings',
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/settings',
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
                          [
                            '/statistics',
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
            ],
    ),
  ],
);
