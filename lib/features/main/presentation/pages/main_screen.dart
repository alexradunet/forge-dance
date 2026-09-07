import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../design_system/organisms/navigation/app_bottom_nav.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../routing/routes.dart';

const _immersiveRoutePrefixes = [Routes.workoutSession];

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

    return PopScope(
      canPop: location != Routes.workout,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop && location == Routes.workout) {
          MainTabDestination.home.go(context);
        }
      },
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Scaffold(
          backgroundColor: AppColors.bgDeep,
          body: child,
          bottomNavigationBar: showBottomNav
              ? AppBottomNav(
                  currentIndex: MainTabDestination.fromLocation(location)
                      .tabIndex,
                  onTabChange: (index) =>
                      MainTabDestination.values[index].go(context),
                )
              : null,
        ),
      ),
    );
  }
}
