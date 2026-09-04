import 'package:flutter/material.dart';

import '../../../../design_system/organisms/navigation/app_bottom_nav.dart';
import '../../../../routing/routes.dart';

const _immersiveRoutePrefixes = [Routes.workout];

bool _usesImmersiveSessionShell(String location) =>
    location.contains('/lesson/') ||
    _immersiveRoutePrefixes.any((route) => location.startsWith(route));

class MainScreen extends StatelessWidget {
  const MainScreen({required this.child, required this.location, super.key});

  final Widget child;
  final String location;

  @override
  Widget build(BuildContext context) {
    final showBottomNav = !_usesImmersiveSessionShell(location);

    return Scaffold(
      body: Stack(
        children: [
          child,
          if (showBottomNav)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: AppBottomNav(
                currentIndex: MainTabDestination.fromLocation(
                  location,
                ).tabIndex,
                onTabChange: (index) =>
                    MainTabDestination.values[index].go(context),
              ),
            ),
        ],
      ),
    );
  }
}
