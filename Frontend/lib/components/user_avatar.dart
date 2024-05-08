import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

const iconSize = 36.0;

class UserAvatar extends StatefulWidget {
  const UserAvatar({super.key, this.userId});

  final String? userId;

  @override
  State<UserAvatar> createState() => _UserAvatarState();
}

class _UserAvatarState extends State<UserAvatar> {
  Future<String?> getUserIconURL(String? userID) => Supabase.instance.client
      .rpc<String?>('get_user_avatar_url', params: {'user_id': userID});

  Widget getDefaultUserIcon(ThemeData theme) {
    return ClipOval(
      child: Container(
        height: iconSize,
        width: iconSize,
        color: theme.colorScheme.secondary,
        child: Icon(
          Icons.person,
          color: theme.colorScheme.onSecondary,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    UserStore userStore = context.read<UserStore>();

    return SizedBox(
      height: iconSize,
      width: iconSize,
      child: FutureBuilder(
        future: getUserIconURL(widget.userId ?? userStore.currentUser?.id),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            if (snapshot.hasData && snapshot.data != null) {
              return CircleAvatar(
                  foregroundImage: NetworkImage(snapshot.data!),
                  child: getDefaultUserIcon(theme));
            }
          }

          return getDefaultUserIcon(theme);
        },
      ),
    );
  }
}
