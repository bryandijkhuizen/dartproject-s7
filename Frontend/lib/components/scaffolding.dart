import 'package:darts_application/components/mobile_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Scaffolding extends StatelessWidget {
  const Scaffolding({super.key, required this.shell});

  final StatefulNavigationShell shell;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: shell,
      appBar: AppBar(
        title: Text('Some title'),
        centerTitle: true,
        leading: InkWell(
          child: const Icon(Icons.arrow_back),
          onTap: () {
            print('back button pressed');
          },
        ),
      ),
      bottomNavigationBar: MobileNavBar(
        currentShell: shell,
      ),
    );
  }
}
