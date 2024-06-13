import 'package:darts_application/components/generic_screen.dart';
import 'package:flutter/material.dart';
import 'package:darts_application/features/club_page/views/club_members_view.dart';
import 'package:darts_application/features/club_page/views/upcoming_matches_view.dart';
import 'package:darts_application/features/club_page/views/recent_scores_view.dart';
import 'package:darts_application/features/club_management/views/current_members_manager_view.dart';
import 'package:darts_application/features/club_management/views/new_members_manager_view.dart';
import 'package:darts_application/stores/news_feed_store.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:darts_application/services/post_service.dart';

import 'package:darts_application/features/home/news_feed_scroll_view.dart';

class ClubDetailsView extends StatelessWidget {
  final String clubId;

  const ClubDetailsView({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => NewsFeedStore(context.read<PostService>()),
      child: Consumer<NewsFeedStore>(
        builder: (context, newsFeedStore, child) => Scaffold(
          appBar: AppBar(
            title: const Text('Club Details'),
            centerTitle: true,
          ),
          body: Observer(
            builder: (_) => GenericScreen(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text("<Club image here>"),
                    const SizedBox(height: 24),
                    Text('Posts',
                        style: Theme.of(context).textTheme.titleMedium),
                    const Card(
                      elevation: 0,
                      child: SizedBox(
                          height: 500,
                          child: NewsFeedScrollView(enableShowMore: true)),
                    ),
                    const SizedBox(
                      height: 12,
                    ),
                    Text(
                      'Club Members',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 12),
                    const Card(
                      elevation: 0,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: ClubMembersView(),
                      ),
                    ),
                    const SizedBox(height: 12),
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
                                    builder: (context) =>
                                        const CurrentMembersManagerView(),
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
                                    builder: (context) =>
                                        const NewMembersManagerView(),
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
                      style: Theme.of(context).textTheme.titleMedium,
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
                      style: Theme.of(context).textTheme.titleMedium,
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
          ),
        ),
      ),
    );
  }
}
