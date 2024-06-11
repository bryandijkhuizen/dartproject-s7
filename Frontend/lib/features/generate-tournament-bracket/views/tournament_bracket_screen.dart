import 'package:darts_application/extensions.dart';
import 'package:darts_application/stores/tournament_store.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../tournament_brackets.dart';

class TournamentBracketScreen extends StatelessWidget {
  const TournamentBracketScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TournamentStore store = context.read<TournamentStore>();
    var theme = Theme.of(context);
    var titleLargeWhite = theme.textTheme.titleLarge?.copyWith(
      color: Colors.white,
    );
    var titleMediumWhite =
        theme.textTheme.titleMedium?.copyWith(color: Colors.white);

    return ListView(
      scrollDirection: Axis.vertical,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15.0),
            child: SizedBox(
              width: 1200.00,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 30),
                  Text(
                    "Edit tournament",
                    style: titleLargeWhite,
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Review the proposed matches.",
                  ),
                  const SizedBox(height: 20),
                  Text(
                    "Matches",
                    style: titleMediumWhite,
                  ),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      ElevatedButton(
                        child: const Text("Fill in random"),
                        onPressed: () => {},
                      ),
                      const Spacer(),
                      ElevatedButton(
                        child: const Text("Clear"),
                        onPressed: () => {},
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const TournamentBrackets(),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      const Spacer(),
                      ElevatedButton(
                        child: const Text("Create"),
                        onPressed: () async {
                          var result = await store.createTournament();
                          if (context.mounted) {
                            context.ShowSnackbar(
                              SnackBar(
                                  content: Text(result.success
                                      ? 'Tournament successfully created'
                                      : result.message),
                                  backgroundColor: result.success
                                      ? theme.colorScheme.secondary
                                      : theme.colorScheme.error),
                            );

                            if (result.success) {
                              GoRouter.of(context).go('/matches');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
