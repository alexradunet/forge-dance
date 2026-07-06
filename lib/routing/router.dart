import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/ui/sign_in_screen.dart';
import '../features/authentication/ui/register_screen.dart';
import '../features/authentication/ui/state/authentication_state.dart';
import '../features/authentication/ui/view_model/authentication_view_model.dart';
import '../features/main/presentation/pages/main_screen.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/onboarding/ui/splash_screen.dart';
import '../features/profile/model/profile.dart';
import '../features/profile/ui/account_info_screen.dart';
import '../features/profile/ui/appearances_screen.dart';
import '../features/profile/ui/languages_screen.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/stats/presentation/pages/stats_page.dart';
import 'app_redirect.dart';
import 'routes.dart';

part 'router.g.dart';

enum SlideDirection {
  right,
  left,
  up,
  down,
}

extension GoRouterStateExtension on GoRouterState {
  SlideRouteTransition slidePage(
    Widget child, {
    SlideDirection direction = SlideDirection.left,
  }) {
    return SlideRouteTransition(
      key: pageKey,
      child: child,
      direction: direction,
    );
  }
}

class SlideRouteTransition extends CustomTransitionPage<void> {
  SlideRouteTransition({
    required super.key,
    required super.child,
    SlideDirection direction = SlideDirection.left,
  }) : super(
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            final curve = CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            );

            Offset begin;
            switch (direction) {
              case SlideDirection.right:
                begin = const Offset(-1.0, 0.0);
                break;
              case SlideDirection.left:
                begin = const Offset(1.0, 0.0);
                break;
              case SlideDirection.up:
                begin = const Offset(0.0, 1.0);
                break;
              case SlideDirection.down:
                begin = const Offset(0.0, -1.0);
                break;
            }
            final tween = Tween(begin: begin, end: Offset.zero);
            final offsetAnimation = tween.animate(curve);

            return SlideTransition(
              position: offsetAnimation,
              child: child,
            );
          },
        );
}

/// App router. Navigation guarding is reactive: the router listens to the
/// authentication view model and re-evaluates [computeRedirect] on every
/// auth change (sign-in, sign-out, token revocation), so no screen ever
/// navigates imperatively based on auth state.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  final authState = ValueNotifier<AsyncValue<AuthenticationState>>(
    const AsyncValue.loading(),
  );
  ref
    ..onDispose(authState.dispose)
    ..listen(
      authenticationViewModelProvider,
      (_, next) => authState.value = next,
      fireImmediately: true,
    );

  return GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: authState,
    redirect: (context, state) => computeRedirect(
      matchedLocation: state.matchedLocation,
      auth: authState.value,
    ),
    routes: _routes,
  );
}

final List<GoRoute> _routes = [
    GoRoute(
      path: Routes.splash,
      pageBuilder: (context, state) => state.slidePage(const SplashScreen()),
    ),
    GoRoute(
      path: Routes.register,
      pageBuilder: (context, state) => state.slidePage(const RegisterScreen()),
    ),
    GoRoute(
      path: Routes.login,
      pageBuilder: (context, state) => state.slidePage(const SignInScreen()),
    ),
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) =>
          state.slidePage(const OnboardingScreen()),
    ),
    GoRoute(
      path: Routes.main,
      pageBuilder: (context, state) => state.slidePage(const MainScreen()),
    ),
    GoRoute(
      path: Routes.accountInformation,
      pageBuilder: (context, state) {
        final profile = state.extra as Profile;
        return state.slidePage(AccountInfoScreen(originalProfile: profile));
      },
    ),
    GoRoute(
      path: Routes.appearances,
      pageBuilder: (context, state) =>
          state.slidePage(const AppearancesScreen()),
    ),
    GoRoute(
      path: Routes.languages,
      pageBuilder: (context, state) => state.slidePage(const LanguagesScreen()),
    ),
    GoRoute(
      path: Routes.settings,
      pageBuilder: (context, state) => state.slidePage(
        const SettingsPage(),
        direction: SlideDirection.right,
      ),
    ),
    GoRoute(
      path: Routes.stats,
      pageBuilder: (context, state) => state.slidePage(const StatsPage()),
    ),
  ];
