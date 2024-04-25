import 'package:darts_application/components/user_avatar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsHeader extends StatelessWidget {
  SettingsHeader({super.key});
  final User user = Supabase.instance.client.auth.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const UserAvatar(),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          child: Text(
            overflow: TextOverflow.ellipsis,
            '${user.userMetadata?['email']}',
          ),
        ),
      ],
    );
  }
}
