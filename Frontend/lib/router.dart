import 'package:darts_application/bottom_nav_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

Widget GenericWidget(String text, String route, BuildContext context) {
  return Center(
    child: Column(
      children: [
        Text(text),
        TextButton(
            onPressed: () {
              context.go(route);
            },
            child: Text(route))
      ],
    ),
  );
}

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

final router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/',
  routes: <RouteBase>[
    StatefulShellRoute.indexedStack(
      // Builder for the scaffold including the bottomNavbar
      builder: (context, state, navigationShell) {
        return BottomNavPage(shell: navigationShell);
      },
      branches: <StatefulShellBranch>[
        // Branch for the homepage and subpages
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/',
              builder: (context, state) {
                return GenericWidget('Homescreen', '/statistics', context);
              },
            ),
          ],
        ),

        // Branch for the statistics
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/statistics',
              builder: (context, state) {
                return GenericWidget('Statistics screen', '/', context);
              },
            ),
          ],
        ),

        // Branch for the calendar
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/calendar',
              builder: (context, state) {
                return GenericWidget('Calendar screen', '/', context);
              },
            ),
          ],
        ),

        // Branch for the user settings
        StatefulShellBranch(
          routes: <RouteBase>[
            GoRoute(
              path: '/settings',
              builder: (context, state) {
                return GenericWidget('Settings screen', '/', context);
              },
            ),
          ],
        ),
      ],
    ),
  ],
);
