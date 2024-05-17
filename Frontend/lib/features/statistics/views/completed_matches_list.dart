import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/features/statistics/views/match_statistics_widget.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';
import 'package:darts_application/models/player.dart';
import 'package:darts_application/features/setup_match/match_list.dart';

class CompletedMatchesListWidget extends StatefulWidget {
  const CompletedMatchesListWidget({super.key});

  @override
  _CompletedMatchesListWidgetState createState() =>
      _CompletedMatchesListWidgetState();
}

class _CompletedMatchesListWidgetState
    extends State<CompletedMatchesListWidget> {
  final ScrollController _listViewController = ScrollController();
  final TextEditingController searchTextController = TextEditingController();

  List<MatchModel> matches = [];
  List<PlayerModel> players = [];
  bool isLoading = false;
  bool hasMore = true;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _fetchPlayers().then((_) => _fetchMatches());

    _listViewController.addListener(() {
      if (_listViewController.position.atEdge &&
          _listViewController.position.pixels != 0) {
        _fetchMatches();
      }
    });
  }

  Future<void> _fetchMatches({bool refresh = false}) async {
    if (isLoading) return;

    setState(() {
      isLoading = true;
      if (refresh) {
        currentPage = 1;
        hasMore = true;
        matches.clear();
      }
    });

    final response =
        await Supabase.instance.client.rpc('get_completed_matches');

    final newMatches =
        (response as List).map((json) => MatchModel.fromJson(json)).toList();
    if (newMatches.isNotEmpty) {
      setState(() {
        matches.addAll(newMatches);
        currentPage++;
      });
    } else {
      setState(() {
        hasMore = false;
      });
    }

    setState(() {
      isLoading = false;
    });

    if (players.isEmpty) {
      final userResponse = await Supabase.instance.client.rpc('get_users');
      players = (userResponse as List)
          .map((json) => PlayerModel.fromJson(json))
          .toList();
    }
  }

  Future<void> _fetchPlayers() async {
    final userResponse = await Supabase.instance.client.rpc('get_users');

    setState(() {
      players = (userResponse as List)
          .map((json) => PlayerModel.fromJson(json))
          .toList();
    });
  }

  String getPlayerName(String playerId) {
    final player = players.firstWhere((player) => player.id == playerId);
    return player.lastName;
  }

  void _navigateToStatistics(String matchId) {
    router.push('/statistics/$matchId');
  }

  @override
  void dispose() {
    searchTextController.dispose();
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Matches',
            style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchTextController,
              decoration: const InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(),
              ),
              onSubmitted: (value) => _fetchMatches(refresh: true),
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _fetchMatches(refresh: true),
              child: ListView.separated(
                controller: _listViewController,
                itemCount: matches.length + (hasMore ? 1 : 0),
                separatorBuilder: (context, index) => const Divider(height: 1),
                itemBuilder: (context, index) {
                  if (index < matches.length) {
                    final match = matches[index];
                    return ListTile(
                      title: Text(
                          '${getPlayerName(match.player1Id)} vs ${getPlayerName(match.player2Id)}'),
                      subtitle: Text('Date: ${match.date}'),
                      trailing: ElevatedButton(
                        onPressed: () => _navigateToStatistics(match.id),
                        child: const Text('View stats'),
                      ),
                    );
                  } else if (hasMore) {
                    return const Padding(
                      padding: EdgeInsets.symmetric(vertical: 32),
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return Container(); // Empty container if no more items
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
