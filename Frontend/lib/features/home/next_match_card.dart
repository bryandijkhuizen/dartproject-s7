import 'package:darts_application/models/match.dart';
import 'package:darts_application/stores/next_match_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class NextMatchCard extends StatefulWidget {
  const NextMatchCard({super.key});

  @override
  State<NextMatchCard> createState() => _NextMatchCardState();
}

class _NextMatchCardState extends State<NextMatchCard> {
  late final NextMatchStore nextMatchStore;

  @override
  void initState() {
    super.initState();
    nextMatchStore = context.read<NextMatchStore>();
    // Load next match for current user
    nextMatchStore.loadNextMatch(context.read<UserStore>().currentUser?.id);
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Observer(
      builder: (context) {
        Widget child = const Text('No match found');

        if (nextMatchStore.nextMatchError != null) {
          child = Text(nextMatchStore.nextMatchError!);
        }

        if (nextMatchStore.nextMatch == null &&
            nextMatchStore.nextMatchError == null) {
          child = const Center(child: CircularProgressIndicator());
        }

        if (nextMatchStore.nextMatch != null) {
          MatchModel model = nextMatchStore.nextMatch!;

          child = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: model.player1LastName == 'Unknown'
                          ? 'To be decided'
                          : model.player1LastName,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const TextSpan(
                      text: ' vs ',
                    ),
                    TextSpan(
                      text: model.player2LastName == 'Unknown'
                          ? 'To be decided'
                          : model.player2LastName,
                      style: theme.textTheme.titleMedium!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Date: ',
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: DateFormat('EEEE, MMM d, y - HH:mm').format(
                        model.date.toLocal(),
                      ),
                    )
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  style: theme.textTheme.bodyMedium,
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Location: ',
                      style: theme.textTheme.titleSmall!.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: model.location,
                    )
                  ],
                ),
              ),
            ],
          );
        }

        return Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: child,
          ),
        );
      },
    );
  }
}
