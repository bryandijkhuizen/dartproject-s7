import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'club_members_store.g.dart';

class ClubMembersStore = _ClubMembersStore with _$ClubMembersStore;

abstract class _ClubMembersStore with Store {
  final SupabaseClient _supabaseClient;
  final String clubId;

  _ClubMembersStore(this._supabaseClient, {required this.clubId});

  @observable
  ObservableList<Member> members = ObservableList<Member>();

  @observable
  bool isLoading = false;

  @action
  Future fetchMembers() async {
    isLoading = true;
    try {
      final response = await _supabaseClient
          .rpc('get_club_members_avatars', params: {'p_club_id': clubId});

      final memberData = response as List<dynamic>;
      members = ObservableList<Member>.of(
          memberData.map((m) => Member.fromJson(m as Map<String, dynamic>)));
    } catch (e) {
      print('Error loading members: $e');
    } finally {
      isLoading = false;
    }
  }
}

class Member {
  final String fullName;
  final String avatarUrl;

  Member({required this.fullName, required this.avatarUrl});

  factory Member.fromJson(Map<String, dynamic> json) {
    return Member(
      fullName: json['full_name'],
      avatarUrl: json['avatar_url'],
    );
  }
}
