import 'package:darts_application/features/statistics/components/match_card.dart';
import 'package:darts_application/features/statistics/controllers/completed_matches_controller.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/features/statistics/controllers/statistics_data_controller.dart';

class CompletedMatchesListWidget extends StatefulWidget {
  const CompletedMatchesListWidget({super.key});

  @override
  _CompletedMatchesListWidgetState createState() =>
      _CompletedMatchesListWidgetState();
}

class _CompletedMatchesListWidgetState
    extends State<CompletedMatchesListWidget> {
  final CompletedMatchesController _controller = CompletedMatchesController();
  final ScrollController _listViewController = ScrollController();

  @override
  void initState() {
    super.initState();
    _controller.init();
    _listViewController.addListener(() {
      if (_listViewController.position.atEdge &&
          _listViewController.position.pixels != 0) {
        _controller.fetchMatches();
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
            onPressed: () => _controller.fetchMatches(refresh: true),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: RefreshIndicator(
              onRefresh: () => _controller.fetchMatches(refresh: true),
              child: StreamBuilder(
                stream: _controller.matchesStream,
                builder: (context, snapshot) {
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  final matches = snapshot.data!;
                  return ListView.separated(
                    controller: _listViewController,
                    itemCount: matches.length + (_controller.hasMore ? 1 : 0),
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1, color: Colors.grey),
                    itemBuilder: (context, index) {
                      if (index < matches.length) {
                        return MatchCard(
                            match: matches[index], controller: _controller);
                      } else if (_controller.hasMore) {
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
