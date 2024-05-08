import 'package:darts_application/models/club.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'clubs_store.g.dart';

class ClubsStore = _ClubsStore with _$ClubsStore;

abstract class _ClubsStore with Store {
  final SupabaseClient _supabase;
  final UserStore _userStore;

  _ClubsStore(this._supabase, this._userStore) {
    _fetchUserClubs();
  }

  @observable
  bool loading = true;

  @observable
  List<Club> assignedClubs = [];

  @action
  Future<void> _fetchUserClubs() async {
    loading = true;
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
    loading = false;
  }
}
