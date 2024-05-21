import 'package:darts_application/features/clubs/club_card_image.dart';
import 'package:darts_application/features/clubs/club_location.dart';
import 'package:darts_application/helpers.dart';
import 'package:darts_application/models/club.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ClubCard extends StatelessWidget {
  final Club club;
  const ClubCard({super.key, required this.club});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      elevation: 0,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.0),
        onTap: () {
          context.push('/clubs/${club.id}');
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                club.name,
                style: theme.textTheme.titleLarge!.copyWith(
                  shadows: [
                    textShadow,
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ClubLocation(
                    location: club.city,
                  ),
                  ClubCardImage(
                    bannerImageURL: club.bannerImageURL,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
