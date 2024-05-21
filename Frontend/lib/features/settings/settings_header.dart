import 'package:darts_application/components/user_avatar.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class SettingsHeader extends StatefulWidget {
  SettingsHeader({super.key});

  @override
  State<SettingsHeader> createState() => _SettingsHeaderState();
}

class _SettingsHeaderState extends State<SettingsHeader> {
  @override
  Widget build(BuildContext context) {
    UserStore userStore = context.read<UserStore>();

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const UserAvatar(
          iconSize: 48,
        ),
        const SizedBox(
          width: 12,
        ),
        Flexible(
          child: Observer(
            builder: (_) => Text(
              overflow: TextOverflow.ellipsis,
              '${userStore.currentUser?.userMetadata?['first_name']} ${userStore.currentUser?.userMetadata?['last_name']}',
            ),
          ),
        ),
      ],
    );
  }
}
