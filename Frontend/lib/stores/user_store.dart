import 'package:darts_application/models/permissions.dart';
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
      if (authChange.event != AuthChangeEvent.tokenRefreshed &&
          authChange.event != AuthChangeEvent.signedOut &&
          authChange.event != AuthChangeEvent.initialSession) {
        AuthResponse response = await supabase.auth.refreshSession();
        currentSession = response.session;
      }
    });
  }

  @observable
  Session? currentSession;

  @computed
  User? get currentUser => currentSession?.user;

  @computed
  Permissions get permissions {
    // Haal de token payload op vanuit de sessie, indien aanwezig
    Map<String, dynamic>? tokenPayload = currentSession?.accessToken != null
        ? JwtDecoder.decode(currentSession!.accessToken)
        : null;
    List<String> systemPermissions = [];
    Map<int, List<String>> clubPermissions = {};
    // Haal de permissies op en zet ze om naar een List<String>
    if (tokenPayload != null &&
        tokenPayload['app_metadata'] != null &&
        tokenPayload['app_metadata']['app_permissions'] != null) {
      List<dynamic>? dynamicPermissions =
          tokenPayload['app_metadata']['app_permissions']['system_permissions'];

      // Converteer naar een List<String>
      if (dynamicPermissions != null) {
        systemPermissions = dynamicPermissions
            .map((permission) => permission.toString())
            .toList();
      }
    }
    if (tokenPayload != null &&
        tokenPayload['app_metadata'] != null &&
        tokenPayload['app_metadata']['app_permissions'] != null) {
      Map<String, dynamic>? dynamicPermissions =
          tokenPayload['app_metadata']['app_permissions']['club_permissions'];

      if (dynamicPermissions != null) {
        dynamicPermissions.forEach((key, value) {
          int intKey = int.parse(key);
          if (value is List && value.every((element) => element is String)) {
            clubPermissions[intKey] = List<String>.from(value);
          }
        });
      }
    }
    return Permissions(systemPermissions, clubPermissions);
  }
}
