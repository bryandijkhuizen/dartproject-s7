import 'package:darts_application/components/desktop_nav_bar.dart';
import 'package:darts_application/components/mobile_nav_bar.dart';
import 'package:darts_application/helpers.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Scaffolding extends StatelessWidget {
  const Scaffolding({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: shell,
        appBar: !isMobile
            ? DesktopNavBar(
                currentShell: shell,
              )
            : null,
        bottomNavigationBar: isMobile
            ? MobileNavBar(
                currentShell: shell,
              )
            : null,
      ),
    );
  }
}
