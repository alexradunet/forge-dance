import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:go_router/go_router.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'main_navigation.dart';
import '../features/home/presentation/pages/home_page.dart';
import '../features/explore/presentation/pages/explore_page.dart';
import '../features/library/presentation/pages/collection_page.dart';
import '../features/profile/presentation/pages/profile_page.dart';
import '../features/workout/presentation/pages/training_session_page.dart';
import '../features/vocabulary/repository/vocabulary_repository.dart';
import '../features/vocabulary/ui/vocabulary_page.dart';
import '../features/vocabulary/ui/vocabulary_entry_page.dart';
import '../features/learn/ui/module_view_screen.dart';
import '../features/learn/ui/prototype/learning_roadmap_prototype.dart';
import '../features/skill_progression/prototype/ui/skill_progression_prototype.dart';
import '../features/learn/ui/lesson_player_screen.dart';
import '../features/learn/ui/view_model/learn_view_model.dart';
import '../features/onboarding/ui/onboarding_screen.dart';
import '../features/onboarding/ui/splash_screen.dart';
import '../features/profile/model/profile.dart';
import '../features/profile/ui/view_model/profile_view_model.dart';
import '../features/profile/ui/account_info_screen.dart';
import '../features/profile/ui/appearances_screen.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../features/stats/presentation/pages/stats_page.dart';
import 'app_redirect.dart';
import '../features/method/ui/method_page.dart';
import '../features/practice/ui/practice_page.dart';
import '../features/practice/ui/practice_log_page.dart';
import '../features/settings/presentation/pages/data_transfer_page.dart';
import 'routes.dart';

part 'router.g.dart';

enum SlideDirection { right, left, up, down }

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

           return SlideTransition(position: offsetAnimation, child: child);
         },
       );
}

/// App router. Navigation guarding is reactive: the router listens to the
/// local profile and re-evaluates [computeRedirect] whenever first-run setup
/// completes.
@Riverpod(keepAlive: true)
GoRouter router(Ref ref) {
  // The listener refreshes redirects without replacing navigation history.
  final profileState = ValueNotifier(ref.read(profileViewModelProvider));
  ref
    ..onDispose(profileState.dispose)
    ..listen(
      profileViewModelProvider,
      (_, next) => profileState.value = next,
      fireImmediately: true,
    );

  final router = GoRouter(
    initialLocation: Routes.splash,
    refreshListenable: profileState,
    redirect: (context, state) => computeRedirect(
      matchedLocation: state.matchedLocation,
      profileState: profileState.value,
    ),
    routes: _routes(ref),
  );
  ref.onDispose(router.dispose);
  return router;
}

List<RouteBase> _routes(Ref ref) {
  return [
    GoRoute(
      path: Routes.splash,
      pageBuilder: (context, state) => state.slidePage(const SplashScreen()),
    ),
    GoRoute(
      path: Routes.onboarding,
      pageBuilder: (context, state) =>
          state.slidePage(const OnboardingScreen()),
    ),
    GoRoute(path: Routes.main, redirect: (_, _) => Routes.home),
    GoRoute(path: Routes.library, redirect: (_, _) => Routes.vocabulary),
    mainNavigation([
      GoRoute(
        path: Routes.vocabulary,
        builder: (_, _) => const VocabularyPage(),
        routes: [
          GoRoute(
            path: ':entryId',
            redirect: (_, state) =>
                const VocabularyRepository().byId(
                      state.pathParameters['entryId']!,
                    ) ==
                    null
                ? Routes.vocabulary
                : null,
            builder: (context, state) => VocabularyEntryPage(
              entry: const VocabularyRepository().byId(
                state.pathParameters['entryId']!,
              )!,
              onBack: () => context.pop(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.explore,
        builder: (_, state) {
          final variant = state.uri.queryParameters['variant'];
          if (kDebugMode && roadmapPrototypeVariants.contains(variant)) {
            return LearningRoadmapPrototype(
              variant: variant!,
              initialSearch: state.uri.queryParameters['search'],
            );
          }
          return const ExplorePage();
        },
        routes: [
          GoRoute(
            path: 'history',
            builder: (context, _) =>
                CollectionPage(onBack: () => context.pop()),
          ),
        ],
      ),
      GoRoute(path: Routes.home, builder: (_, _) => const HomePage()),
      GoRoute(path: Routes.method, builder: (_, _) => const MethodPage()),
      GoRoute(
        path: Routes.practice,
        builder: (_, _) => const PracticePage(),
        routes: [
          GoRoute(path: 'log', builder: (_, _) => const PracticeLogPage()),
        ],
      ),
      GoRoute(path: Routes.programmes, redirect: (_, _) => Routes.explore),
      GoRoute(
        path: Routes.workout,
        builder: (context, _) => TrainingSessionPage(
          onClose: () => closeDetail(context, fallback: Routes.practice),
          onStart: () => context.push(Routes.workoutSession),
        ),
        routes: [
          GoRoute(
            path: 'session',
            builder: (context, _) => TrainingSessionPage(
              startImmediately: true,
              onClose: () => context.pop(),
            ),
          ),
        ],
      ),
      GoRoute(
        path: Routes.profile,
        builder: (_, state) {
          final variant = state.uri.queryParameters['variant'];
          if (kDebugMode && skillPrototypeVariants.contains(variant)) {
            return SkillProgressionPrototype(variant: variant!);
          }
          return const ProfilePage();
        },
      ),
      GoRoute(
        path: '${Routes.main}/module/:moduleId',
        builder: (context, state) {
          final moduleId = state.pathParameters['moduleId']!;
          return ModuleViewScreen(
            moduleId: moduleId,
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
              final learn = ref.read(learnViewModelProvider).value;
              if (learn == null || !learn.canOpenLesson(lessonId)) {
                return ModuleViewScreen(
                  moduleId: moduleId,
                  onBack: () => context.pop(),
                );
              }
              return LessonPlayerScreen(
                lessonId: lessonId,
                onBack: () => context.pop(),
              );
            },
          ),
        ],
      ),
    ]),
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
    GoRoute(
      path: Routes.dataTransfer,
      pageBuilder: (context, state) =>
          state.slidePage(const DataTransferPage()),
    ),
  ];
}
