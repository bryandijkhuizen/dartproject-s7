import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/features/settings/settings_header.dart';
import 'package:darts_application/features/settings/settings_item.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  @override
  Widget build(BuildContext context) {
    UserStore userStore = context.read<UserStore>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        centerTitle: true,
      ),
      body: GenericScreen(
        child: Column(
          children: [
            SettingsHeader(),
            const SizedBox(
              height: 24,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16.0,
                        ),
                        child: Observer(
                          builder: (_) => Column(
                            children: [
                              SettingsItem(
                                callback: () {
                                  context.push('/settings/name');
                                },
                                title: 'Name',
                                value:
                                    '${userStore.currentUser?.userMetadata?['first_name']} ${userStore.currentUser?.userMetadata?['last_name']}',
                              ),
                              SettingsItem(
                                callback: () {
                                  context.push('/settings/email');
                                },
                                title: 'Email',
                                value: '${userStore.currentUser?.email}',
                              ),
                              SettingsItem(
                                callback: () {
                                  context.push('/settings/password');
                                },
                                title: 'Password',
                                value: '********',
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Supabase.instance.client.auth.signOut();
                },
                child: const Text('Sign out'))
          ],
        ),
      ),
    );
  }
}
