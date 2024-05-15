import 'package:darts_application/features/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/features/gameplay/numpad.dart';
import 'package:darts_application/features/gameplay/score_input.dart';
import 'package:darts_application/features/gameplay/scoreboard.dart';
import 'package:go_router/go_router.dart';
import 'package:darts_application/features/gameplay/score_suggestion.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchView extends StatelessWidget {
  final String matchId;
  const MatchView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (context) => MatchStore(Supabase.instance.client, matchId),
      builder: (context, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Match', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            router.push('/matches');
          },
        ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 8.0),
                child: Center(
                  child: Observer(builder: (_) {
                    MatchStore matchStore = context.read<MatchStore>();
                    if (!matchStore.setupComplete) {
                      return const Text(
                        'Loading match info...',
                        style: TextStyle(fontSize: 14, color: Colors.white),
                        textAlign: TextAlign.center,
                      );
                    }
                    return Text(
                      'Match ID: $matchId | ${matchStore.matchModel.startingScore} | First to ${matchStore.matchModel.legTarget} legs${matchStore.matchModel.setTarget > 1 ? ', ${matchStore.matchModel.setTarget} sets' : ''}',
                      style: const TextStyle(fontSize: 14, color: Colors.white),
                    );
                  }),
                ),
              ),
            ],
          ),
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/bg.png"),
                fit: BoxFit.cover,
              ),
            ),
            child: Builder(builder: (context) {
              return Observer(builder: (_) {
                MatchStore matchStore = context.read<MatchStore>();

                if (matchStore.errorMessage.isNotEmpty) {
                  return _errorScreen(context, matchStore.errorMessage);
                }

                if (matchStore.isLoading) {
                  return _loadingScreen(matchStore.loadingMessage);
                }

                if (matchStore.matchEnded) {
                  return _endOfMatchScreen(matchStore, context);
                }

                return _gameScreen(matchStore);
              });
            }),
          ),
        );
      },
    );
  }

  Widget _errorScreen(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error, color: Colors.red, size: 80),
          const SizedBox(height: 20),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              context.read<MatchStore>().errorMessage = '';
              Navigator.of(context).maybePop();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            child: const Text('Go Back', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _loadingScreen(String loadingMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(loadingMessage),
        ],
      ),
    );
  }

  Widget _endOfMatchScreen(MatchStore matchStore, BuildContext context) {
    bool isPlayer1Winner =
        matchStore.matchWinnerId == matchStore.matchModel.player1Id;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            '${matchStore.matchModel.player1LastName}: ${matchStore.legWins[matchStore.matchModel.player1Id] ?? 0}',
            style: TextStyle(
              color: isPlayer1Winner ? Colors.yellow : Colors.white,
              fontSize: 24,
            ),
          ),
          const Text('vs', style: TextStyle(color: Colors.white, fontSize: 24)),
          Text(
            '${matchStore.matchModel.player2LastName}: ${matchStore.legWins[matchStore.matchModel.player2Id] ?? 0}',
            style: TextStyle(
              color: !isPlayer1Winner ? Colors.yellow : Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (route) => false),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text(
              'Quit and Save Game',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  Widget _gameScreen(MatchStore matchStore) {
    return Column(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: Scoreboard(matchStore: matchStore),
        ),
        SizedBox(
          height: 60,
          child: AnimatedAngledBox(),
        ),
        Container(
          height: 90,
          padding: const EdgeInsets.only(top: 5),
          child: ScoreInput(matchStore: matchStore),
        ),
        Expanded(
          flex: 3,
          child: Container(
            padding: const EdgeInsets.only(top: 5, bottom: 10),
            child: Numpad(matchStore: matchStore),
          ),
        ),
      ],
    );
  }
}
