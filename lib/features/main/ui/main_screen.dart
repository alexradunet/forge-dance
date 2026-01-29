import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../../../features/home/ui/home_screen.dart';
import '../../../features/library/ui/library_screen.dart';
import '../../../features/profile/ui/profile_screen.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/tokens/app_typography.dart';

const List<Widget> _screens = [
  HomeScreen(),
  LibraryScreen(), // Learn/Library screen
  HomeScreen(), // Social screen (placeholder)
  ProfileScreen(),
];

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  late PersistentTabController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  List<PersistentBottomNavBarItem> _navBarsItems(
    BuildContext context,
    Color selectedColor,
    Color unselectedColor,
  ) {
    return [
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.home),
        inactiveIcon: const Icon(Icons.home_outlined),
        title: 'Home',
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        textStyle: AppTheme.caption,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.school),
        inactiveIcon: const Icon(Icons.school_outlined),
        title: 'Learn',
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        textStyle: AppTheme.caption,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.people),
        inactiveIcon: const Icon(Icons.people_outline),
        title: 'Social',
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        textStyle: AppTheme.caption,
      ),
      PersistentBottomNavBarItem(
        icon: const Icon(Icons.person),
        inactiveIcon: const Icon(Icons.person_outline),
        title: 'Profile',
        activeColorPrimary: selectedColor,
        inactiveColorPrimary: unselectedColor,
        textStyle: AppTheme.caption,
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final selectedColor = AppColors.forgeFire;
    final unselectedColor = AppColors.gray400;
    return Scaffold(
      body: PersistentTabView(
        context,
        controller: _controller,
        screens: _screens,
        items: _navBarsItems(
          context,
          selectedColor,
          unselectedColor,
        ),
        confineToSafeArea: true,
        backgroundColor: AppColors.gray800,
        handleAndroidBackButtonPress: true,
        resizeToAvoidBottomInset: true,
        stateManagement: true,
        hideNavigationBarWhenKeyboardAppears: true,
        decoration: NavBarDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
          colorBehindNavBar: AppColors.gray950,
        ),
        popBehaviorOnSelectedNavBarItemPress: PopBehavior.all,
        animationSettings: const NavBarAnimationSettings(
          navBarItemAnimation: ItemAnimationSettings(
            // Navigation Bar's items animation properties.
            duration: Duration(milliseconds: 400),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: ScreenTransitionAnimationSettings(
            // Screen transition animation on change of selected tab.
            animateTabTransition: true,
            duration: Duration(milliseconds: 300),
            screenTransitionAnimationType: ScreenTransitionAnimationType.fadeIn,
          ),
          onNavBarHideAnimation: OnHideAnimationSettings(
            duration: Duration(milliseconds: 100),
            curve: Curves.bounceInOut,
          ),
        ),
        navBarStyle: NavBarStyle.style1,
      ),
    );
  }
}
