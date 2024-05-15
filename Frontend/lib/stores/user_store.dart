import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final SupabaseClient supabase;

  _UserStore(this.supabase) : currentUser = supabase.auth.currentUser {
    // Add listener to update user observable
    supabase.auth.onAuthStateChange.listen((authChange) {
      AuthChangeEvent event = authChange.event;

      if (event == AuthChangeEvent.userUpdated) {
        currentUser = authChange.session?.user;
      }
    });
  }

  @observable
  User? currentUser;
}
