import 'package:darts_application/features/club_management/views/current_members_manager_view.dart';
import 'package:darts_application/features/club_page/stores/club_members_store.dart';
import 'package:darts_application/features/club_page/stores/club_user_store.dart';
import 'package:darts_application/models/club.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/features/club_management/views/edit_club_info_view.dart';
import 'package:darts_application/features/club_page/views/club_members_view.dart';
import 'package:darts_application/features/club_management/views/new_members_manager_view.dart';
import 'package:darts_application/features/home/news_feed_scroll_view.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:darts_application/stores/news_feed_store.dart';
import 'package:darts_application/services/post_service.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/permissions.dart';

class ClubDetailsView extends StatelessWidget {
  final int clubId;

  const ClubDetailsView({super.key, required this.clubId});

  @override
  Widget build(BuildContext context) {
    UserStore userStore = context.read<UserStore>();
    Permissions permissions = userStore.permissions;

    return MultiProvider(
      providers: [
        Provider<NewsFeedStore>(
          create: (_) =>
              NewsFeedStore(context.read<PostService>())..clubIds = [clubId],
        ),
        Provider<ClubUserStore>(
          create: (_) => ClubUserStore(Supabase.instance.client,
              clubId: clubId, userId: userStore.currentUser!.id),
        ),
        Provider<ClubMembersStore>(
          create: (_) =>
              ClubMembersStore(Supabase.instance.client, clubId: clubId),
          child: const ClubMembersView(),
        ),
      ],
      child: Consumer3<NewsFeedStore, ClubUserStore, ClubsStore>(
        builder: (context, newsFeedStore, clubUserStore, clubsStore, _) {
          Club club = clubsStore.clubs.firstWhere((club) => club.id == clubId);
          clubUserStore.checkMembership();

          return Observer(
            builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text('Club Details'),
                centerTitle: true,
              ),
              body: GenericScreen(
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (club.bannerImageURL.isNotEmpty)
                        Hero(
                          tag: club.bannerImageURL,
                          child: ClipRRect(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(12),
                            ),
                            child: Image.network(club.bannerImageURL),
                          ),
                        ),
                      if (!clubUserStore.isMember && !clubUserStore.isLoading)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 12.0),
                          child: ElevatedButton(
                            onPressed: () async {
                              final clubUserStore = Provider.of<ClubUserStore>(
                                  context,
                                  listen: false);
                              bool success =
                                  await clubUserStore.applyForMembership();
                              if (success) {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'You have requested membership successfully.'),
                                  duration: Duration(seconds: 3),
                                ));
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content: Text(
                                      'Failed to request membership. Please try again.'),
                                  duration: Duration(seconds: 3),
                                ));
                              }
                            },
                            child: const Text('Apply to Join Club'),
                          ),
                        ),
                      Text('Posts',
                          style: Theme.of(context).textTheme.titleMedium),
                      const Card(
                        elevation: 0,
                        child: SizedBox(
                          height: 500,
                          child: NewsFeedScrollView(
                            enableShowMore: true,
                            enableHeader: false,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text('Club Members',
                          style: Theme.of(context).textTheme.titleMedium),
                      const SizedBox(height: 12),
                      const Card(
                        elevation: 0,
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 16.0),
                          child: ClubMembersView(),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (permissions.checkClubPermission(
                          PermissionList.manageClubMembers))
                        ClubManagementButtons(context),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget ClubManagementButtons(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 12),
        Text('Club Management', style: Theme.of(context).textTheme.titleMedium),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const NewMembersManagerView()),
            );
          },
          child: const Text('New Members'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => const CurrentMembersManagerView()),
            );
          },
          child: const Text('Current Members'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const EditClubInfoView()),
            );
          },
          child: const Text('Edit club info'),
        ),
      ],
    );
  }
}
