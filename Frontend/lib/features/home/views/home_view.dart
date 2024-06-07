import 'package:darts_application/features/home/news_feed_scroll_view.dart';
import 'package:darts_application/components/club_card.dart';
import 'package:darts_application/features/home/next_match_card.dart';
import 'package:darts_application/services/match_service.dart';
import 'package:darts_application/services/post_service.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:darts_application/stores/news_feed_store.dart';
import 'package:darts_application/stores/next_match_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  SliverStickyHeader createSection(String title, Widget? body,
      {List<Widget>? actions}) {
    return SliverStickyHeader(
      header: AppBar(
        title: Text(title),
        actions: actions,
      ),
      sliver: SliverPadding(
        padding: const EdgeInsets.symmetric(
          horizontal: 16.0,
          vertical: 24.0,
        ),
        sliver: SliverToBoxAdapter(
          child: body,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ClubsStore clubsStore = context.read<ClubsStore>();

    return MultiProvider(
      providers: [
        Provider(
          create: (_) => NewsFeedStore(
            context.read<PostService>(),
          ),
        ),
        Provider(
          create: (_) => NextMatchStore(
            context.read<MatchService>(),
          ),
        ),
      ],
      child: LayoutBuilder(
        builder: (context, constraints) {
          NextMatchStore nextMatchStore = context.read<NextMatchStore>();

          bool wideVariant = constraints.maxWidth > 600;

          var mainBodySlivers = [
            createSection(
              'Friendly match',
              Column(
                children: [
                  const Text(
                      'Create a match to play against people from your club!'),
                  const SizedBox(
                    height: 8,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      context.go('/matches/create/single');
                    },
                    child: const Text('Create friendly match'),
                  ),
                  const SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
            createSection(
              'Next match',
              const NextMatchCard(),
              actions: [
                IconButton(
                  onPressed: () {
                    nextMatchStore.loadNextMatch(
                        context.read<UserStore>().currentUser?.id);
                  },
                  icon: const Icon(Icons.refresh),
                ),
              ],
            ),
            createSection(
                'Your clubs',
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Become a member of clubs by going to the club page and signing up for a club!',
                      textAlign: TextAlign.center,
                    ),
                    ClubCard(
                      titleEnabled: false,
                    ),
                    SizedBox(
                      height: 16,
                    ),
                  ],
                ),
                actions: [
                  IconButton(
                    onPressed: () {
                      clubsStore.fetchUserClubs();
                    },
                    icon: const Icon(Icons.refresh),
                  ),
                ]),
          ];

          return Column(
            children: [
              Expanded(
                child: wideVariant
                    ? _buildWideVariant(
                        [...mainBodySlivers],
                      )
                    : _buildSmallVariant(
                        prefixSlivers: mainBodySlivers,
                      ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildWideVariant(List<Widget> slivers) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 840),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: CustomScrollView(
              slivers: slivers,
            ),
          ),
          const SizedBox(
            width: 48,
          ),
          const Expanded(
            child: NewsFeedScrollView(),
          ),
        ],
      ),
    );
  }

  Widget _buildSmallVariant(
      {List<Widget>? prefixSlivers, List<Widget>? suffixSlivers}) {
    return NewsFeedScrollView(
      prefixSlivers: prefixSlivers,
      suffixSlivers: suffixSlivers,
    );
  }
}
