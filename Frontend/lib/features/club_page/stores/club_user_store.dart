import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'club_user_store.g.dart';

class ClubUserStore = _ClubUserStore with _$ClubUserStore;

abstract class _ClubUserStore with Store {
  final SupabaseClient _supabaseClient;

  final String clubId;
  final String userId;

  _ClubUserStore(this._supabaseClient,
      {required this.clubId, required this.userId});

  @observable
  bool isLoading = false;

  @observable
  bool isMember = false;

  @action
  Future checkMembership() async {
    isLoading = true;

    try {
      final response = await _supabaseClient.rpc('is_user_member_of_club',
          params: {'p_user_id': userId, 'p_club_id': clubId});

      isMember = response == true;
    } catch (e) {
      print('Error checking membership: $e');
    } finally {
      isLoading = false;
    }
  }

  @action
  Future<bool> applyForMembership() async {
    isLoading = true;

    try {
      await _supabaseClient.rpc('add_user_to_club',
          params: {'p_user_id': userId, 'p_club_id': clubId});

      return true;
    } catch (e) {
      print('Error applying for club membership: $e');
      return false;
    } finally {
      isLoading = false;
    }
  }
}
