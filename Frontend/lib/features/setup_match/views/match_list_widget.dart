// ignore_for_file: unused_element

import 'package:darts_application/features/create_match/create_single_match_page.dart';
import 'package:darts_application/features/setup_match/match_list.dart';
import 'package:darts_application/features/setup_match/stores/match_setup_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:darts_application/models/match.dart';

class MatchListWidget extends StatefulWidget {
  const MatchListWidget({super.key});

  @override
  _MatchListWidgetState createState() => _MatchListWidgetState();
}

class _MatchListWidgetState extends State<MatchListWidget> {
  late Future<Map<String, List<MatchModel>>> _matchesFuture;
  late String currentUserId;
  MatchSetupStore matchSetupStore = MatchSetupStore(
      Supabase.instance.client, UserStore(Supabase.instance.client));

  @override
  void initState() {
    super.initState();
    _matchesFuture = matchSetupStore.fetchMatches();
  }

  Future<void> _fetchMatches() async {
    setState(() {
      _matchesFuture = matchSetupStore.fetchMatches();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Matches', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchMatches,
          ),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('./assets/images/bg.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: RefreshIndicator(
          onRefresh: _fetchMatches,
          child: Column(
            children: [
              FutureBuilder<Map<String, List<MatchModel>>>(
                future: _matchesFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (snapshot.hasData) {
                    final pendingMatches = snapshot.data!['pending_matches']!;
                    final activeMatches = snapshot.data!['active_matches']!;
                    return Expanded(
                      child: ListView(
                        children: [
                          MatchList(
                            title: 'Pending Matches',
                            matches: pendingMatches,
                          ),
                          MatchList(
                            title: 'Active Matches',
                            matches: activeMatches,
                          ),
                        ],
                      ),
                    );
                  } else {
                    return const Center(child: Text('No matches found.'));
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.only(
                    bottom: 16.0), // Add margin at the bottom
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                                const CreateSingleMatchPage()));
                  },
                  child: const Text('Create Match'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
