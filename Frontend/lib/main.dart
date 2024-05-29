import 'package:darts_application/constants.dart';
import 'package:darts_application/features/app_router/app_router.dart';
import 'package:darts_application/stores/clubs_store.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:darts_application/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() {
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
