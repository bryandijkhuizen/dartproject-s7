import 'package:darts_application/models/club.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SettingsClubItem extends StatelessWidget {
  final Club club;
  final double iconSize;
  final double iconSpacing;
  const SettingsClubItem(
      {super.key,
      required this.club,
      required this.iconSize,
      required this.iconSpacing});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return TextButton(
      onPressed: () {
        context.push('/clubs/${club.id}');
      },
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: NetworkImage(club.bannerImageURL),
            radius: iconSize / 2,
            backgroundColor: theme.colorScheme.secondary,
          ),
          SizedBox(
            width: iconSpacing,
          ),
          Text(club.name, style: theme.textTheme.bodyMedium),
          Expanded(child: Container()),
          const Icon(Icons.chevron_right),
        ],
      ),
    );
  }
}
