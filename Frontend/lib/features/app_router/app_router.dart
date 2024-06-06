import 'package:darts_application/components/scaffolding.dart';
import 'package:darts_application/features/app_router/app_router_redirect.dart';
import 'package:darts_application/features/auth/auth_notifier.dart';
import 'package:darts_application/features/auth/auth_view.dart';
import 'package:darts_application/features/clubs/views/club_overview.dart';
import 'package:darts_application/features/clubs/views/club_registration_view.dart';
import 'package:darts_application/features/create_match/single_match/create_single_match_page.dart';
import 'package:darts_application/features/create_match/single_match/edit_single_match_page.dart';
import 'package:darts_application/features/club_management/views/club_management.dart';
import 'package:darts_application/features/avatar_picker/views/avatar_picker_view.dart';
import 'package:darts_application/features/settings/views/settings_email_view.dart';
import 'package:darts_application/features/settings/views/settings_name_view.dart';
import 'package:darts_application/features/settings/views/settings_password_view.dart';
import 'package:darts_application/features/settings/views/settings_view.dart';
import 'package:darts_application/features/user_management/views/user_management_assign_view.dart';
import 'package:darts_application/features/user_management/views/user_management_view.dart';
import 'package:darts_application/features/setup_match/views/match_list_widget.dart';
import 'package:darts_application/features/statistics/views/completed_matches_list.dart';
import 'package:darts_application/features/statistics/views/match_statistics_widget.dart';
import 'package:darts_application/features/upcoming_matches/upcoming_matches_page.dart';
import 'package:darts_application/features/generate-tournament-bracket/views/tournament_bracket_screen.dart';
import 'package:darts_application/helpers.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:darts_application/features/gameplay/views/match_view.dart';
import 'package:darts_application/features/gameplay/views/desktop_match_view.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:darts_application/features/setup_match/start_match.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Widget helloComponent = const Center(
  child: Text('Hello!'),
);

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');

// SettingsRoute is identical on mobile and desktop
final settingsBranch = StatefulShellBranch(
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
        ),
        GoRoute(
          path: 'avatar',
          builder: (context, state) {
            return const AvatarPickerView();
          },
        ),
      ],
    ),
  ],
);

final clubsBranch = StatefulShellBranch(
  routes: <RouteBase>[
    GoRoute(
      path: '/clubs',
      builder: (context, state) => const ClubOverview(),
      routes: <RouteBase>[
        GoRoute(
          path: 'register',
          builder: (context, state) => const ClubRegistrationView(),
        ),
        GoRoute(
          path: ':id',
          builder: (context, state) {
            return const Placeholder();
          },
        ),
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
                      return helloComponent;
                    },
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
                          final matchIdString =
                              state.pathParameters['matchId']!;
                          final matchId = int.parse(matchIdString);
                          return MatchStatisticsWidget(
                            matchId: matchId,
                            isDesktop: false,
                          );
                        },
                      ),
                    ],
                    builder: (context, state) {
                      return const CompletedMatchesListWidget();
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
                        routes: [
                          GoRoute(
                            path: 'gameplay',
                            builder: (context, state) {
                              final matchId = state.pathParameters['matchId']!;
                              return MatchView(matchId: matchId);
                            },
                          ),
                        ],
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
              settingsBranch,
              clubsBranch,
            ]
          // Desktop branches
          : [
              // Desktop Home
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/',
                    builder: (context, state) {
                      List<PlayerModel> players = [
                        PlayerModel.placeholderPlayer(),
                        PlayerModel.placeholderPlayer()
                      ];

                      return ElevatedButton(
                          onPressed: () {
                            context.push(
                              '/matches/create_tournament',
                              extra: {
                                'players': players,
                                'setTarget': 3,
                                'legTarget': 5,
                                'startingScore': 501,
                              },
                            );
                          },
                          child: const Text(
                              'Go to tournament bracket view with some list'));
                      // Ignore this for now
                      return helloComponent;
                    },
                  ),
                ],
              ),

              // Desktop statistics
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/statistics',
                    routes: <RouteBase>[
                      GoRoute(
                        path: ':matchId',
                        builder: (context, state) {
                          final matchIdString =
                              state.pathParameters['matchId']!;
                          final matchId = int.parse(matchIdString);
                          return MatchStatisticsWidget(
                              matchId: matchId, isDesktop: true);
                        },
                      ),
                    ],
                    builder: (context, state) {
                      return const CompletedMatchesListWidget();
                    },
                  ),
                ],
              ),

              // Desktop match overview
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    path: '/matches',
                    builder: (context, state) {
                      return const UpcomingMatchesPage();
                    },
                    routes: <RouteBase>[
                      GoRoute(
                        path: 'create_tournament',
                        builder: (context, state) {
                          // TODO: Fallback error screen als je geen player list hebt
                          final data = state.extra! as Map<String, dynamic>;

                          // final List<PlayerModel> tournament = data['tournament'];
                          final List<PlayerModel> players = data['players'];
                          final int setTarget = data['setTarget'];
                          final int legTarget = data['legTarget'];
                          final int startingScore = data['startingScore'];

                          return Provider(
                            create: (_) => TournamentStore(
                              Supabase.instance.client,
                              // tournament,
                              players,
                              setTarget,
                              legTarget,
                              startingScore,
                            ),
                            child: const TournamentBracketScreen(),
                          );
                        },
                      ),
                      GoRoute(
                        path: 'edit',
                        builder: (context, state) {
                          final match = state.extra as Map<String, dynamic>;
                          return EditSingleMatchPage(match: match);
                        },
                      ),
                      GoRoute(
                        path: 'create/single',
                        builder: (context, state) {
                          return const CreateSingleMatchPage();
                        },
                      ),
                      GoRoute(
                        path: ':matchId/gameplay',
                        builder: (context, state) {
                          final matchId = state.pathParameters['matchId']!;
                          return DesktopMatchView(matchId: matchId);
                        },
                      ),
                    ],
                  ),
                ],
              ),

              // Branch for user management
              StatefulShellBranch(
                routes: <RouteBase>[
                  GoRoute(
                    redirect: (context, state) {
                      UserStore userStore = context.read<UserStore>();
                      if ((!userStore.permissions.systemPermissions.contains(
                              PermissionList.assignRole.permissionName)) &&
                          (!userStore.permissions.checkClubPermission(
                              PermissionList.assignClubRole))) {
                        return '/';
                      }
                      return null;
                    },
                    path: '/user-management',
                    builder: (context, state) {
                      // Ignore this for now
                      return const UserManagementView();
                    },
                    routes: [
                      GoRoute(
                        path: 'edit/:uuid',
                        builder: (context, state) {
                          return UserManagementAssignView(
                              uuid: state.pathParameters['uuid']!);
                        },
                      )
                    ],
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
                      return ClubManagement();
                    },
                  ),
                ],
              ),

              settingsBranch,
              clubsBranch,
            ],
    ),
  ],
);
