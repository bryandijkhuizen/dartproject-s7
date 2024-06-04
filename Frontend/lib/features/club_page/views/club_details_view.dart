import 'package:darts_application/components/generic_screen.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/features/club_page/views/club_members_view.dart';
import 'package:darts_application/features/club_page/views/upcoming_matches_view.dart';
import 'package:darts_application/features/club_page/views/recent_scores_view.dart';
import 'package:darts_application/features/club_page/views/club_posts_view.dart';
import 'package:darts_application/features/club_management/views/current_members_manager_view.dart';
import 'package:darts_application/features/club_management/views/new_members_manager_view.dart';

class ClubDetailsView extends StatefulWidget {
  final String clubId;

  const ClubDetailsView({super.key, required this.clubId});

  @override
  ClubDetailsViewState createState() => ClubDetailsViewState();
}

class ClubDetailsViewState extends State<ClubDetailsView> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Details'),
        centerTitle: true,
      ),
      body: GenericScreen(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text("<Club image here>"),
              const SizedBox(
                height: 24,
              ),
              Text(
                'Posts',
                style: theme.textTheme.titleMedium,
              ),
              Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: ClubPostsView(clubId: widget.clubId, limit: 3),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Club Members',
                style: theme.textTheme.titleMedium,
              ),
              const Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: ClubMembersView(),
                ),
              ),              const SizedBox(
                height: 12,
              ),
                            Card(
                elevation: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const CurrentMembersManagerView(),
                            ),
                          );
                        },
                        child: const Text('Current Members'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewMembersManagerView(),
                            ),
                          );
                        },
                        child: const Text('New Members'),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Upcoming Matches',
                style: theme.textTheme.titleMedium,
              ),
              const Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: UpcomingMatchesView(),
                ),
              ),
              const SizedBox(
                height: 12,
              ),
              Text(
                'Recent Scores',
                style: theme.textTheme.titleMedium,
              ),
              const Card(
                elevation: 0,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: RecentScoresView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
