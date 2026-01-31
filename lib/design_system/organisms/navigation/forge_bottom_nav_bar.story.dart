import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ForgeBottomNavBar,
  path: 'Design System/Organisms/Navigation',
)
Widget buildForgeBottomNavBar(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: const SizedBox(),
    bottomNavigationBar: ForgeBottomNavBar(
      currentIndex: 0,
      items: const [
        ForgeNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        ForgeNavItem(
          label: 'Explore',
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
        ),
        ForgeNavItem(
          label: 'Stats',
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
        ),
        ForgeNavItem(
          label: 'Profile',
          icon: Icons.person_outline,
          activeIcon: Icons.person,
        ),
      ],
      onTap: (_) {},
      onFabPressed: () {},
    ),
  );
}

@widgetbook.UseCase(
  name: 'Active Explore',
  type: ForgeBottomNavBar,
  path: 'Design System/Organisms/Navigation',
)
Widget buildForgeBottomNavBarExplore(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: const SizedBox(),
    bottomNavigationBar: ForgeBottomNavBar(
      currentIndex: 1,
      items: const [
        ForgeNavItem(
          label: 'Home',
          icon: Icons.home_outlined,
          activeIcon: Icons.home,
        ),
        ForgeNavItem(
          label: 'Explore',
          icon: Icons.explore_outlined,
          activeIcon: Icons.explore,
        ),
        ForgeNavItem(
          label: 'Stats',
          icon: Icons.bar_chart_outlined,
          activeIcon: Icons.bar_chart,
        ),
        ForgeNavItem(
          label: 'Profile',
          icon: Icons.person_outline,
          activeIcon: Icons.person,
        ),
      ],
      onTap: (_) {},
      onFabPressed: () {},
    ),
  );
}
