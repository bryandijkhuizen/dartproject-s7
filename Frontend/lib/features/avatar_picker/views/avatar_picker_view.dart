import 'package:darts_application/components/form_save_button.dart';
import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/extensions.dart';
import 'package:darts_application/features/app_router/app_router_extensions.dart';
import 'package:darts_application/features/avatar_picker/avatar_grid_item.dart';
import 'package:darts_application/features/avatar_picker/current_avatar.dart';
import 'package:darts_application/stores/avatar_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class AvatarPickerView extends StatefulWidget {
  const AvatarPickerView({super.key});

  @override
  State<AvatarPickerView> createState() => _AvatarPickerViewState();
}

class _AvatarPickerViewState extends State<AvatarPickerView> {
  String errorMsg = '';

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    int crossAxisCount = screenWidth ~/ 128;
    ThemeData theme = Theme.of(context);

    return Provider<AvatarStore>(
        create: (_) => AvatarStore(
            Supabase.instance.client, Provider.of<UserStore>(context)),
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: const Text('Change your avatar'),
          ),
          body: GenericScreen(
            child: Builder(
              builder: (context) {
                AvatarStore avatarStore = Provider.of<AvatarStore>(context);

                return Column(
                  children: [
                    const CurrentAvatar(),
                    const SizedBox(height: 4.0),
                    Text(
                      errorMsg,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                    const SizedBox(height: 4.0),
                    Expanded(
                      child: Observer(
                        builder: (context) {
                          if (!avatarStore.initialized) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          return GridView.count(
                            crossAxisCount: crossAxisCount,
                            crossAxisSpacing: 8.0,
                            mainAxisSpacing: 8.0,
                            children: Provider.of<AvatarStore>(context)
                                .avatars
                                .toList()
                                .map((avatar) => AvatarGridItem(
                                      avatar: avatar,
                                      selected: avatar.id ==
                                          avatarStore.previewAvatar?.id,
                                      callback: (url) {
                                        avatarStore.changePreview(avatar);
                                      },
                                    ))
                                .toList(),
                          );
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    FormSaveButton(
                      onCancel: () {
                        context.goBack('/settings');
                      },
                      onSave: () async {
                        if (avatarStore.previewAvatar == null) {
                          return setState(() {
                            errorMsg = 'Please select an avatar first';
                          });
                        }

                        await avatarStore.saveAvatar().then((result) {
                          // Navigate back
                          context.goBack('/settings');

                          // Show snackbar based on result
                          context.ShowSnackbar(
                            SnackBar(
                              content: Text(result.message),
                              backgroundColor: result.success
                                  ? theme.colorScheme.secondary
                                  : theme.colorScheme.error,
                            ),
                          );
                        });
                      },
                    ),
                  ],
                );
              },
            ),
          ),
        ));
  }
}
