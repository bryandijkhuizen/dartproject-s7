import 'package:darts_application/constants.dart';
import 'package:darts_application/router.dart';
import 'package:darts_application/theme.dart';
import 'package:flutter/material.dart';
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
    return MaterialApp.router(
      title: 'Flutter Demo',
      themeMode: ThemeMode.dark,
      darkTheme: darkTheme,
      routerConfig: router,
    );
  }
}
