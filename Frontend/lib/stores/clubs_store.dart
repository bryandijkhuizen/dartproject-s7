import 'package:darts_application/models/club.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'clubs_store.g.dart';

class ClubsStore = _ClubsStore with _$ClubsStore;

abstract class _ClubsStore with Store {
  final SupabaseClient _supabase;
  final UserStore _userStore;

  _ClubsStore(this._supabase, this._userStore);

  // Clubs
  @observable
  List<Club> clubs = [];

  @observable
  int queryResults = 0;

  int pageLimit = 100;
  List<int> loadedPages = [];
  String lastSearchPrompt = '';

  @action
  Future<void> _fetchClubsPage(int page, [String searchPrompt = '']) async {
    // If page is already loaded, skip this fetch
    if (loadedPages.contains(page)) return;

    try {
      loadedPages.add(page);
      final int offSet = (page - 1) * pageLimit;
      final int limit = page * pageLimit - 1;

      final response = await _supabase
          .from('club')
          .select()
          .ilike('name', '%$searchPrompt%')
          .range(offSet, limit)
          .count();

      queryResults = response.count;

      List<Map<String, dynamic>> dataMap =
          List<Map<String, dynamic>>.from(response.data);

      // Add fetched clubs to the list of clubs
      clubs.addAll(
        dataMap.map<Club>(
          (club) => Club.fromJson(club),
        ),
      );
    } on PostgrestException catch (error) {
      if (error.code == 'PGRST103') {
        // PGRST103: Offset is not satisfiable
        return;
      }
    } catch (error) {
      print('Error fetching user clubs: $error');
      // Handle error accordingl
    }
  }

  @action
  Future<void> fetch(int page, [String searchPrompt = '']) async {
    if (lastSearchPrompt != searchPrompt) {
      clubs.clear();
      loadedPages.clear();
    }

    // Update searchPrompt
    lastSearchPrompt = searchPrompt;

    return _fetchClubsPage(page, searchPrompt);
  }

// Assigned clubs
  @observable
  bool loadingAssignedClubs = false;

  @observable
  List<Club> assignedClubs = [];

  @action
  Future<void> fetchUserClubs() async {
    loadingAssignedClubs = true;
    try {
      final response = await _supabase.rpc('get_user_clubs',
          params: {'p_user_id': _userStore.currentUser?.id});

      List<Map<String, dynamic>> dataMap =
          List<Map<String, dynamic>>.from(response);

      assignedClubs = dataMap
          .map<Club>(
            (club) => Club.fromJson(club),
          )
          .toList();
    } catch (error) {
      print('Error fetching user clubs: $error');
      // Handle error accordingly
    }
    loadingAssignedClubs = false;
  }
}
