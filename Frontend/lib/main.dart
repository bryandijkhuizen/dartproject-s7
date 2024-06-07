import 'package:darts_application/constants.dart';
import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/services/match_service.dart';
import 'package:darts_application/services/post_service.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:darts_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:win32_registry/win32_registry.dart';
import 'dart:io';

Future<void> registerScheme(String scheme) async {
  String appPath = Platform.resolvedExecutable;

  String protocolRegKey = 'Software\\Classes\\$scheme';
  RegistryValue protocolRegValue = const RegistryValue(
    'URL Protocol',
    RegistryValueType.string,
    '',
  );
  String protocolCmdRegKey = 'shell\\open\\command';
  RegistryValue protocolCmdRegValue = RegistryValue(
    '',
    RegistryValueType.string,
    '"$appPath" "%1"',
  );

  final regKey = Registry.currentUser.createKey(protocolRegKey);
  regKey.createValue(protocolRegValue);
  regKey.createKey(protocolCmdRegKey).createValue(protocolCmdRegValue);
}

void main() {
  // Register scheme for windows if we're on Windows
  if (Platform.isWindows) {
    registerScheme('dartinmolema');
  }

  Supabase.initialize(
    url: Constants.supabaseUrl,
    anonKey: Constants.supabaseAnonKey,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Provider(
      create: (_) => UserStore(Supabase.instance.client),
      child: Builder(
        builder: (context) => MultiProvider(
          providers: [
            Provider<ClubsStore>(
              create: (_) => ClubsStore(
                Supabase.instance.client,
                context.read<UserStore>(),
              ),
            ),
            Provider(
              create: (_) => MatchService(
                Supabase.instance.client,
              ),
            ),
            Provider(
              create: (_) => PostService(Supabase.instance.client),
            ),
          ],
          child: MaterialApp.router(
            title: 'Flutter Demo',
            themeMode: ThemeMode.dark,
            darkTheme: darkTheme,
            routerConfig: router,
          ),
        ),
      ),
    );
  }
}
