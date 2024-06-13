import 'package:darts_application/features/create_match/single_match/create_single_match_page.dart';
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
  MatchSetupStore matchSetupStore = MatchSetupStore(
      Supabase.instance.client, UserStore(Supabase.instance.client));

  TextEditingController searchController = TextEditingController();
  List<MatchModel> allMatches = [];
  List<MatchModel> filteredMatches = [];
  bool showAll = false;
  bool isLoading = true;
  String? errorMessage;

  void advanceMatch() async {
    await Supabase.instance.client
        .rpc('advance_tournament_match', params: {'p_match_id': '3'});
  }

  @override
  void initState() {
    super.initState();
    _fetchMatches();
    searchController.addListener(_filterMatches);
    advanceMatch();
  }

  Future<void> _fetchMatches() async {
    try {
      final matches = await matchSetupStore.fetchMatches();
      setState(() {
        allMatches = [
          ...matches['pending_matches']!,
          ...matches['active_matches']!
        ];
        _filterMatches(); // Ensure filteredMatches is set initially
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
        errorMessage = 'Error fetching matches: $e';
      });
    }
  }

  void _filterMatches() {
    String query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      setState(() {
        filteredMatches = allMatches.take(5).toList();
        showAll = false;
      });
    } else {
      setState(() {
        filteredMatches = allMatches.where((match) {
          return match.player1LastName.toLowerCase().contains(query) ||
              match.player2LastName.toLowerCase().contains(query);
        }).toList();
        showAll = true; // Show all matches that match the query
      });
    }
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: TextField(
                  controller: searchController,
                  decoration: InputDecoration(
                    labelText: 'Search Matches',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                ),
              ),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : errorMessage != null
                      ? Center(child: Text(errorMessage!))
                      : Expanded(
                          child: ListView(
                            children: [
                              MatchList(
                                title: 'Matches',
                                matches: showAll
                                    ? filteredMatches
                                    : filteredMatches.take(5).toList(),
                              ),
                              if (!showAll && filteredMatches.length > 5)
                                TextButton(
                                  onPressed: () {
                                    setState(() {
                                      showAll = true;
                                      filteredMatches = allMatches;
                                    });
                                  },
                                  child: const Text('Show more'),
                                ),
                            ],
                          ),
                        ),
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
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
