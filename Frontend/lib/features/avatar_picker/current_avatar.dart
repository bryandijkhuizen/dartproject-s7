import 'package:darts_application/stores/avatar_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class CurrentAvatar extends StatelessWidget {
  const CurrentAvatar({super.key});

  @override
  Widget build(BuildContext context) {
    AvatarStore avatarStore = context.read<AvatarStore>();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text('Current avatar: '),
        Observer(builder: (context) {
          if (avatarStore.previewAvatar != null) {
            return Image.network(
              height: 128,
              width: 128,
              fit: BoxFit.fitWidth,
              avatarStore.previewAvatar!.url,
              errorBuilder: (context, error, stackTrace) =>
                  const Text('Something went wrong'),
            );
          }

          return const Text('No avatar selected');
        }),
      ],
    );
  }
}
