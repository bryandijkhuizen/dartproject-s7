import 'package:darts_application/components/generic_screen.dart';
import 'package:darts_application/features/settings/settings_header.dart';
import 'package:darts_application/features/settings/settings_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  User user = Supabase.instance.client.auth.currentUser!;

  @override
  Widget build(BuildContext context) {
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
                        child: Column(
                          children: [
                            SettingsItem(
                              callback: () {
                                context.go('/settings/name');
                              },
                              title: 'Name',
                              value:
                                  '${user.userMetadata?['first_name']} ${user.userMetadata?['last_name']}',
                            ),
                            SettingsItem(
                              title: 'Email',
                              value: '${user.userMetadata?['email']}',
                            ),
                            const SettingsItem(
                              title: 'Password',
                              value: '********',
                            ),
                          ],
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
