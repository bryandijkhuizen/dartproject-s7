import 'package:darts_application/models/club.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'clubs_store.g.dart';

class ClubsStore = _ClubsStore with _$ClubsStore;

abstract class _ClubsStore with Store {
  final SupabaseClient supabase;

  _ClubsStore(this.supabase) {
    // Listen to club changes for current user
  }

  @observable
  List<Club> clubs = [];
}
