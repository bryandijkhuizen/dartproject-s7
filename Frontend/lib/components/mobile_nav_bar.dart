import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MobileNavBar extends StatelessWidget {
  const MobileNavBar({super.key, required this.currentShell});

  final StatefulNavigationShell currentShell;

  void _goBranch(int index) {
    currentShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == currentShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> platformDestinations = const [
      NavigationDestination(
        icon: Icon(Icons.home),
        label: "Home",
      ),
      NavigationDestination(
        icon: Icon(Icons.bar_chart),
        label: "Statistics",
      ),
      NavigationDestination(
        icon: Icon(Icons.calendar_month),
        label: "Matches",
      ),
      NavigationDestination(
        icon: Icon(Icons.settings),
        label: "Settings",
      ),
    ];

    return NavigationBar(
      onDestinationSelected: _goBranch,
      selectedIndex: currentShell.currentIndex,
      destinations: platformDestinations,
    );
  }
}
