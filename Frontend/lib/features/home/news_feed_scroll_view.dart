import 'package:darts_application/features/club_page/widgets/post_card.dart';
import 'package:darts_application/stores/news_feed_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class NewsFeedScrollView extends StatelessWidget {
  final List<Widget>? prefixSlivers;
  final List<Widget>? suffixSlivers;

  const NewsFeedScrollView({super.key, this.prefixSlivers, this.suffixSlivers});

  @override
  Widget build(BuildContext context) {
    NewsFeedStore newsFeedStore = context.read();
    ThemeData theme = Theme.of(context);
    return CustomScrollView(
      slivers: [
        ...?prefixSlivers,
        SliverStickyHeader(
          header: AppBar(
            title: const Text('Latest news'),
            actions: [
              IconButton(
                onPressed: () async {
                  if (!newsFeedStore.loading) {
                    await newsFeedStore.reloadPosts();
                  }
                },
                icon: const Icon(Icons.refresh),
              ),
            ],
          ),
          sliver: Observer(
            builder: (context) {
              if (newsFeedStore.loading) {
                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              if (newsFeedStore.posts.isEmpty) {
                return SliverToBoxAdapter(
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        'No posts found',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                  ),
                );
              }

              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) => PostCard(
                    post: newsFeedStore.posts[index],
                    onTap: () {
                      context
                          .go('/clubs/posts/${newsFeedStore.posts[index].id}');
                    },
                  ),
                  childCount: newsFeedStore.posts.length,
                ),
              );
            },
          ),
        ),
        ...?suffixSlivers,
      ],
    );
  }
}
