import 'package:darts_application/components/scaffolding.dart';
import 'package:darts_application/features/app_router/app_router_redirect.dart';
import 'package:darts_application/features/auth/auth_notifier.dart';
import 'package:darts_application/features/auth/auth_view.dart';
import 'package:darts_application/helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
  initialLocation: '/auth',
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
                    builder: (context, state) {
                      // Ignore this for now
                      return getPlaceholderComponent(
                          '/matches',
                          [
                            '/',
                            '/statistics',
                            '/settings',
                          ],
                          context);
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
