import 'package:go_router/go_router.dart';

import '../features/main/presentation/pages/main_screen.dart';
import 'routes.dart';
import 'shell_navigation_observer.dart';

/// Each primary destination owns a retained navigator. Detail URLs stay stable.
StatefulShellRoute mainNavigation(List<GoRoute> routes) {
  final observers = [
    for (final _ in MainTabDestination.values) ShellNavigationObserver(),
  ];
  return StatefulShellRoute.indexedStack(
    builder: (context, state, shell) => MainScreen(
      location: state.uri.path,
      currentIndex: shell.currentIndex,
      canChangeTab: () => observers[shell.currentIndex].canChangeTab,
      onTabChange: (index) =>
          shell.goBranch(index, initialLocation: index == shell.currentIndex),
      child: shell,
    ),
    branches: [
      for (final tab in MainTabDestination.values)
        StatefulShellBranch(
          initialLocation: tab.location,
          observers: [observers[tab.tabIndex]],
          routes: [
            for (final route in routes)
              if (MainTabDestination.fromLocation(route.path) == tab) route,
          ],
        ),
    ],
  );
}
