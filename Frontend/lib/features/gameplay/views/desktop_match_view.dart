import 'package:darts_application/features/app_router/app_router.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/stores/match_store.dart';
import 'package:darts_application/features/gameplay/desktop_score_input.dart';
import 'package:darts_application/features/gameplay/desktop_scoreboard.dart';

class DesktopMatchView extends StatelessWidget {
  final String matchId;
  const DesktopMatchView({super.key, required this.matchId});

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
          padding: const EdgeInsets.all(16.0),
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/bg.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Consumer<MatchStore>(
            builder: (context, matchStore, child) {
              return KeyboardListener(
                focusNode: FocusNode(),
                onKeyEvent: (event) {
                  if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.enter)) {
                    matchStore.recordScore(int.parse(matchStore.temporaryScore));
                    matchStore.updateTemporaryScore('');
                  }
                  if (HardwareKeyboard.instance.isLogicalKeyPressed(LogicalKeyboardKey.keyZ)) {
                    matchStore.undoLastScore();
                  }
                },
                child: Observer(builder: (_) {
                  if (matchStore.errorMessage.isNotEmpty) {
                    return _errorScreen(context, matchStore.errorMessage);
                  }

                  if (matchStore.isLoading) {
                    return _loadingScreen(matchStore.loadingMessage);
                  }

                  if (matchStore.matchEnded) {
                    return _endOfMatchScreen(matchStore, context);
                  }

                  if (matchStore.doubleAttemptsNeeded) {
                    return _showCheckoutDialog(context, matchStore);
                  }

                  return _gameScreen(matchStore);
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _errorScreen(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          const Icon(Icons.error, color: Color(0xFFCD0612), size: 80),
          const SizedBox(height: 20),
          Text(
            errorMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              router.push('/matches/$matchId/gameplay');
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCD0612),
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
            onPressed: () {
              router.push('/');
            },
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
          flex: 2,
          child: DesktopScoreboard(matchStore: matchStore),
        ),
        Expanded(
          flex: 1,
          child: DesktopScoreInput(matchStore: matchStore),
        ),
      ],
    );
  }

  Widget _showCheckoutDialog(BuildContext context, MatchStore matchStore) {
    TextEditingController dartsController = TextEditingController();
    TextEditingController attemptsController = TextEditingController();

    return AlertDialog(
      backgroundColor: Colors.grey[850],
      title: const Text(
        'Enter Checkout Details',
        style: TextStyle(color: Colors.white),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: dartsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Darts for Checkout',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
          TextField(
            controller: attemptsController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'Double Attempts',
              labelStyle: TextStyle(color: Colors.white.withOpacity(0.8)),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white.withOpacity(0.8)),
              ),
              focusedBorder: const UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.white),
              ),
            ),
            style: const TextStyle(color: Colors.white),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            matchStore.doubleAttemptsNeeded = false;
            Navigator.of(context).pop();
          },
          child: const Text('Cancel', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () {
            int dartsForCheckout = int.parse(dartsController.text);
            int doubleAttempts = int.parse(attemptsController.text);
            matchStore.recordScore(
              int.parse(matchStore.temporaryScore),
              dartsForCheckout: dartsForCheckout,
              doubleAttempts: doubleAttempts,
            );
            matchStore.doubleAttemptsNeeded = false;
            Navigator.of(context).pop();
          },
          child: const Text('Submit', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }
}
