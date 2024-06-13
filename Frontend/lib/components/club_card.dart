import 'package:darts_application/features/settings/settings_club_item.dart';
import 'package:darts_application/models/club.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

const double textButtonPadding = 12;
const double iconSize = 32;
const double iconSpacing = 12;

class ClubCard extends StatelessWidget {
  final bool titleEnabled;
  const ClubCard({super.key, this.titleEnabled = true});

  Widget getLoadingIndicator() => const Center(
        child: CircularProgressIndicator(),
      );

  Widget getUserClubs(List<Club> clubs) {
    if (clubs.isEmpty) {
      return const Center(
        child: Text('You are not a club member'),
      );
    }

    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return SettingsClubItem(
          club: clubs[index],
          iconSize: iconSize,
          iconSpacing: iconSpacing,
        );
      },
      separatorBuilder: (context, index) => const Divider(
        indent: textButtonPadding + iconSize + iconSpacing,
        endIndent: 12,
      ),
      itemCount: clubs.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ClubsStore clubsStore = context.read<ClubsStore>();
    return Observer(
      builder: (_) {
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          if (titleEnabled)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Assigned clubs',
                  style: theme.textTheme.titleMedium,
                ),
                IconButton(
                  onPressed: () {
                    if (!clubsStore.loadingAssignedClubs) {
                      clubsStore.fetchUserClubs();
                    }
                  },
                  icon: Icon(
                    Icons.refresh,
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          Card(
            elevation: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: clubsStore.loadingAssignedClubs
                  ? getLoadingIndicator()
                  : getUserClubs(clubsStore.assignedClubs),
            ),
          )
        ]);
      },
    );
  }
}
