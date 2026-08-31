import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../features/authentication/ui/sign_in_screen.dart';
import '../features/authentication/ui/register_screen.dart';
import '../features/authentication/ui/state/authentication_state.dart';
import '../features/authentication/ui/view_model/authentication_view_model.dart';
import '../features/main/presentation/pages/main_screen.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/library/presentation/pages/collection_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/workout/presentation/pages/training_session_page.dart';
import '../features/learn/ui/module_view_screen.dart';
import '../features/learn/ui/lesson_player_screen.dart';
import '../features/learn/ui/view_model/learn_view_model.dart';
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
    routes: _routes(ref),
  );
}

List<RouteBase> _routes(Ref ref) => [
      GoRoute(
        path: Routes.splash,
        pageBuilder: (context, state) => state.slidePage(const SplashScreen()),
      ),
      GoRoute(
        path: Routes.register,
        pageBuilder: (context, state) =>
            state.slidePage(const RegisterScreen()),
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
      ShellRoute(
        builder: (context, state, child) => MainScreen(
          location: state.uri.path,
          child: child,
        ),
        routes: [
          GoRoute(path: Routes.main, redirect: (_, _) => Routes.home),
          GoRoute(
            path: Routes.library,
            builder: (_, _) => const CollectionPage(),
          ),
          GoRoute(
            path: Routes.explore,
            builder: (_, _) => const ExplorePage(),
          ),
          GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
          GoRoute(
            path: Routes.workout,
            builder: (_, _) => const TrainingSessionPage(),
          ),
          GoRoute(
              path: Routes.profile, builder: (_, _) => const ProfilePage()),
          GoRoute(
            path: '${Routes.main}/module/:moduleId',
            builder: (context, state) {
              final moduleId = state.pathParameters['moduleId']!;
              ref.read(learnViewModelProvider.notifier).selectModule(moduleId);
              return ModuleViewScreen(
                onBack: () => context.pop(),
                onLessonNavigate: (lessonId) =>
                    LessonDestination(moduleId, lessonId).push<void>(context),
              );
            },
            routes: [
              GoRoute(
                path: 'lesson/:lessonId',
                builder: (context, state) {
                  final moduleId = state.pathParameters['moduleId']!;
                  final lessonId = state.pathParameters['lessonId']!;
                  ref
                      .read(learnViewModelProvider.notifier)
                      .selectModule(moduleId);
                  final learn = ref.read(learnViewModelProvider).value;
                  if (learn == null || !learn.canOpenLesson(lessonId)) {
                    return ModuleViewScreen(onBack: () => context.pop());
                  }
                  return LessonPlayerScreen(
                    lessonId: lessonId,
                    onBack: () => context.pop(),
                  );
                },
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: Routes.accountInformation,
        pageBuilder: (context, state) {
          final profile = state.extra;
          if (profile is! Profile) return state.slidePage(const ProfilePage());
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
        pageBuilder: (context, state) =>
            state.slidePage(const LanguagesScreen()),
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
