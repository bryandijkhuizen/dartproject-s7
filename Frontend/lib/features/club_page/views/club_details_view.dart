import 'package:darts_application/components/generic_screen.dart';
import 'package:flutter/material.dart';
import 'club_members_view.dart';
import 'upcoming_matches_view.dart';
import 'recent_scores_view.dart';
import 'club_posts_view.dart';

class ClubDetailsView extends StatefulWidget {
  const ClubDetailsView({super.key, required String clubId});

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
        child: Column(
          children: [
            Text("<Club image here>"),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      'Posts',
                      style: theme.textTheme.titleMedium,
                    ),
                    const Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Column(
                          children: [ClubPostsView()],
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
                        child: Column(
                          children: [ClubMembersView()],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
