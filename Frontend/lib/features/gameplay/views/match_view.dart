import 'package:darts_application/features/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/features/gameplay/numpad.dart';
import 'package:darts_application/features/gameplay/score_input.dart';
import 'package:darts_application/features/gameplay/scoreboard.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MatchView extends StatelessWidget {
  final String matchId;
  const MatchView({super.key, required this.matchId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Match', style: TextStyle(color: Colors.white)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            router.push('/matches');
          },
        ),
      ),
      body: Provider(
        create: (context) => MatchStore(Supabase.instance.client, matchId),
        child: Container(
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
      ),
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
        ScoreInput(
          matchStore: matchStore,
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
