import 'package:darts_application/models/avatar.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:mobx/mobx.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

part 'avatar_store.g.dart';

class AvatarStore = _AvatarStore with _$AvatarStore;

abstract class _AvatarStore with Store {
  final SupabaseClient _supabase;
  final UserStore _userStore;
  _AvatarStore(this._supabase, this._userStore) {
    // Initialize store
    _initializeStore();

    // Setup listener for auth changes
    _supabase.auth.onAuthStateChange.listen((event) {
      _fetchAvatarUrl(event.session?.user.id);
    });
  }

  @observable
  bool initialized = false;

  @observable
  Iterable<Avatar> avatars = [];

  Future<void> _initializeStore() async {
    try {
      List<Map<String, dynamic>> response =
          await _supabase.from('avatar').select();

      avatars = response.map((avatarData) => Avatar.fromJSON(avatarData));
      initialized = true;

      // fetch initial profile picture
      _fetchAvatarUrl(Supabase.instance.client.auth.currentSession?.user.id);
    } catch (error) {
      // Handle errors
    }
  }

  @observable
  Avatar? previewAvatar;

  Future<void> _fetchAvatarUrl(String? userID) async {
    String? avatarUrl = await _supabase
        .rpc<String?>('get_user_avatar_url', params: {'user_id': userID});

    try {
      if (avatarUrl != null) {
        previewAvatar = avatars.firstWhere((avatar) => avatar.url == avatarUrl);
      }
    } catch (error) {
      // Handle errors
      print(error);
    }
  }

  @action
  changePreview(Avatar newAvatar) {
    previewAvatar = newAvatar;
  }

  @action
  Future<SaveAvatarResult> saveAvatar() async {
    if (previewAvatar == null || _userStore.currentUser == null) {
      return SaveAvatarResult(
          success: false, message: 'No user or avatar selected.');
    }

    try {
      await _supabase.from('user').update({'avatar_id': previewAvatar!.id}).eq(
          'id', _userStore.currentUser!.id);
    } on PostgrestException catch (error) {
      return SaveAvatarResult(
          success: false,
          message: 'Error occurred during saving: ${error.message}');
    } catch (error) {
      return SaveAvatarResult(
          success: false, message: 'Unknown error occurred.');
    }

    return SaveAvatarResult(
        success: true, message: 'Avatar updated successfully.');
  }
}

class SaveAvatarResult {
  final bool success;
  final String message;

  SaveAvatarResult({required this.success, required this.message});
}
