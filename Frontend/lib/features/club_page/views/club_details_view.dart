import 'package:darts_application/components/generic_screen.dart';
import 'package:flutter/material.dart';
import 'club_members_view.dart';
import 'upcoming_matches_view.dart';
import 'recent_scores_view.dart';
import 'club_posts_view.dart';

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
                  padding: EdgeInsets.symmetric(
                    vertical: 16.0,
                  ),
                  child: SizedBox(
                    height: 300,
                    child: ClubPostsView(clubId: widget.clubId),
                  ),
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
