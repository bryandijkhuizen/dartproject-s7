import 'package:darts_application/helpers.dart';
import 'package:flutter/material.dart';

class ClubLocation extends StatelessWidget {
  const ClubLocation({
    super.key,
    required this.location,
  });

  final String location;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      children: [
        const Icon(
          Icons.place,
          shadows: [
            textShadow,
          ],
        ),
        Text(
          location,
          style: theme.textTheme.titleMedium!.copyWith(
            shadows: [
              textShadow,
            ],
          ),
        )
      ],
    );
  }
}
