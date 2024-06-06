import 'package:darts_application/features/statistics/components/match_card.dart';
import 'package:darts_application/features/statistics/stores/statistics_store.dart';
import 'package:darts_application/models/match.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CompletedMatchesListWidget extends StatefulWidget {
  const CompletedMatchesListWidget({super.key});

  @override
  _CompletedMatchesListWidgetState createState() =>
      _CompletedMatchesListWidgetState();
}

class _CompletedMatchesListWidgetState
    extends State<CompletedMatchesListWidget> {
  late StatisticsStore _statisticsStore;
  final ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _statisticsStore = Provider.of<StatisticsStore>(context, listen: false);
    _statisticsStore.init();
    _listViewController.addListener(() {
      if (_listViewController.position.atEdge &&
          _listViewController.position.pixels != 0) {
        _statisticsStore.fetchMatches();
      }
    });
  }

  @override
  void dispose() {
    _listViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Completed Matches',
            style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _statisticsStore.fetchMatches(refresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _statisticsStore.fetchMatches(refresh: true),
              child: StreamBuilder<List<MatchModel>>(
                stream: _statisticsStore.matchesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final matches = snapshot.data!;
                  return ListView.separated(
                    controller: _listViewController,
                    itemCount:
                        matches.length + (_statisticsStore.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      if (index < matches.length) {
                        return MatchCard(
                            match: matches[index],
                            key: ValueKey(matches[index]));
                      } else if (_statisticsStore.hasMore) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(
                              child: CircularProgressIndicator(
                                  color: Color(0xFF00BFA6))),
                        );
                      } else {
                        return Container();
                      }
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
