import 'package:darts_application/components/navigation_divider.dart';
import 'package:darts_application/components/navigation_item.dart';
import 'package:darts_application/models/permission_list.dart';
import 'package:darts_application/models/permissions.dart';
import 'package:darts_application/stores/user_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

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

  void _goBranch(int index) {
    currentShell.goBranch(
      index,
      // A common pattern when using bottom navigation bars is to support
      // navigating to the initial location when tapping the item that is
      // already active.
      initialLocation: index == currentShell.currentIndex,
    );
  }

  List<NavigationItem> getNavigationItems(Permissions permissions) {
    var navigationItems = [
      NavigationItem(
        label: 'Home',
        location: '/',
        active: currentShell.currentIndex == 0,
        callback: () {
          _goBranch(0);
        },
      ),
      NavigationItem(
        label: 'Statistics',
        location: '/statistics',
        active: currentShell.currentIndex == 1,
        callback: () {
          _goBranch(1);
        },
      ),
      NavigationItem(
        label: 'Matches',
        location: '/matches',
        active: currentShell.currentIndex == 2,
        callback: () {
          _goBranch(2);
        },
      ),
      NavigationItem(
        enabled: (permissions.systemPermissions
            .contains(PermissionList.assignRole.permissionName) || permissions.checkClubPermission(PermissionList.assignClubRole)),
        label: 'User management',
        location: '/user-management',
        active: currentShell.currentIndex == 3,
        callback: () {
          _goBranch(3);
        },
      ),
      NavigationItem(
        enabled: permissions.chechClubManagmentRole(),
        label: 'Club management',
        location: '/club-management',
        active: currentShell.currentIndex == 4,
        callback: () {
          _goBranch(4);
        },
      ),
      NavigationItem(
        label: 'Settings',
        location: '/settings',
        active: currentShell.currentIndex == 5,
        callback: () {
          _goBranch(5);
        },
      ),
    ];
    return navigationItems;
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

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
            child: Observer(
              builder: (context) {
                UserStore userStore = context.read();
                List<NavigationItem> navigationItems =
                    getNavigationItems(userStore.permissions);
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (BuildContext _, int index) {
                    return navigationItems[index];
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    if (navigationItems[index].enabled) {
                      return const NavigationDivider();
                    }
                    return Container();
                  },
                  itemCount: navigationItems.length,
                );
              },
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
