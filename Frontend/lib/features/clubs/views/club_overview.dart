import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/components/search_input.dart';
import 'package:darts_application/features/clubs/club_card.dart';
import 'package:darts_application/models/club.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class ClubOverview extends StatefulWidget {
  const ClubOverview({super.key});

  @override
  State<ClubOverview> createState() => _ClubOverviewState();
}

class _ClubOverviewState extends State<ClubOverview> {
  late final ClubsStore clubsStore;
  final TextEditingController searchTextController = TextEditingController();
  final ScrollController _listViewController = ScrollController();

  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    clubsStore = context.read<ClubsStore>();

    _listViewController.addListener(() {
      // Scrolled to the bottom?
      if (_listViewController.position.atEdge &&
          _listViewController.position.pixels != 0) {
        // More clubs to fetch?
        if (clubsStore.queryResults > clubsStore.clubs.length) {
          clubsStore.fetch(currentPage + 1, searchTextController.text);

          setState(() {
            currentPage++;
          });
        }
      }
    });

    //  Load initial clubs
    clubsStore.fetch(currentPage);
  }

  @override
  void dispose() {
    super.dispose();
    searchTextController.dispose();
    _listViewController.dispose();
  }

  Widget getClubsList(List<Club> clubs) {
    return Expanded(
      child: RefreshIndicator(
        child: clubs.isEmpty
            ? const CustomScrollView(
                slivers: [
                  SliverFillRemaining(
                    child: Center(
                      child: Text('No clubs available'),
                    ),
                  ),
                ],
              )
            : ListView.separated(
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _listViewController,
                itemCount: clubs.length + 1,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  if (index < clubs.length) {
                    return ClubCard(club: clubs.elementAt(index));
                  }

                  if (index >= clubsStore.queryResults - 1) {
                    return null;
                  }

                  return const Padding(
                    padding: EdgeInsets.symmetric(vertical: 32),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }),
        onRefresh: () =>
            clubsStore.fetch(currentPage, searchTextController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Clubs'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              context.push("/clubs/register");
            },
            icon: const Icon(Icons.add),
            tooltip: 'Register club',
          ),
        ],
      ),
      body: GenericScreen(
        child: Observer(
          builder: (context) => Column(
            children: [
              SearchInput(
                controller: searchTextController,
                onSearch: () {
                  clubsStore.fetch(1, searchTextController.text);
                },
              ),
              Text(
                'Showing ${clubsStore.queryResults} result${clubsStore.queryResults == 1 ? '' : 's'}',
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 4),
              getClubsList(clubsStore.clubs),
            ],
          ),
        ),
      ),
    );
  }
}
