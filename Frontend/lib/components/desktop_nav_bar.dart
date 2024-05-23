import 'package:darts_application/components/navigation_divider.dart';
import 'package:darts_application/components/navigation_item.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DesktopNavBar extends StatelessWidget implements PreferredSizeWidget {
  final double height;
  final StatefulNavigationShell currentShell;

  const DesktopNavBar({
    super.key,
    this.height = kToolbarHeight,
    required this.currentShell,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    var navigationItems = [
      const NavigationItem(
        label: 'Home',
        location: '/',
      ),
      const NavigationItem(
        label: 'Statistics',
        location: '/statistics',
      ),
      const NavigationItem(
        label: 'Matches',
        location: '/matches',
      ),
      const NavigationItem(
        label: 'User management',
        location: '/user-management',
      ),
      const NavigationItem(
        label: 'Club management',
        location: '/club-management',
      ),
      const NavigationItem(
        label: 'Settings',
        location: '/settings',
      ),
    ];

    // Get current navigationItem (synced with router's branches)
    var currentItem = navigationItems[currentShell.currentIndex];

    // Replace navigationItem to make it active (Replace because its immutable)
    navigationItems[currentShell.currentIndex] = NavigationItem(
      label: currentItem.label,
      location: currentItem.location,
      active: true,
    );

    return Container(
      color: theme.colorScheme.primary,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: [
          Image.asset(
            'assets/images/dartlogo.png',
            height: 60,
            width: 60,
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(vertical: 14),
              scrollDirection: Axis.horizontal,
              itemBuilder: (BuildContext _, int index) {
                return navigationItems[index];
              },
              separatorBuilder: (BuildContext context, int index) =>
                  const NavigationDivider(),
              itemCount: navigationItems.length,
            ),
          ),
          const Text(
            'Login/logout component here',
            style: TextStyle(color: Colors.white),
          )
        ],
      ),
    );
  }
}
