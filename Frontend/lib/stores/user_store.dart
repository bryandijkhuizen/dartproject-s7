import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'user_store.g.dart';

class UserStore = _UserStore with _$UserStore;

abstract class _UserStore with Store {
  final SupabaseClient supabase;

  _UserStore(this.supabase) : currentSession = supabase.auth.currentSession {
    // Add listener to update user observable
    supabase.auth.onAuthStateChange.listen((authChange) async {
      if (authChange.event != AuthChangeEvent.tokenRefreshed) {
        AuthResponse response = await supabase.auth.refreshSession();
        currentSession = response.session;
        print('new session time');
      }
    });
  }

  @observable
  Session? currentSession;

  @computed
  User? get currentUser => currentSession?.user;

  
  @computed
  List<String> get systemPermissions {
    // Haal de token payload op vanuit de sessie, indien aanwezig
    Map<String, dynamic>? tokenPayload = currentSession?.accessToken != null
        ? JwtDecoder.decode(currentSession!.accessToken)
        : null;

    // Haal de permissies op en zet ze om naar een List<String>
    if (tokenPayload != null &&
        tokenPayload['app_metadata'] != null &&
        tokenPayload['app_metadata']['system_permissions'] != null) {
      List<dynamic> dynamicPermissions =
          tokenPayload['app_metadata']['system_permissions'];

      // Converteer naar een List<String>
      List<String> systemPermissions = dynamicPermissions
          .map((permission) => permission.toString())
          .toList();
      return systemPermissions;
    }

    return [];
  }
}
