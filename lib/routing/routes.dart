import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

class Routes {
  Routes._();

  static const splash = '/';
  static const onboarding = '/onboarding';
  static const main = '/main';
  static const library = '/main/library'; // Legacy collection links.
  static const vocabulary = '/main/vocabulary';
  static const lessonHistory = '$explore/history';
  static const explore = '/main/explore';
  static const home = '/main/home';
  static const workout = '/main/workout';
  static const workoutSession = '$workout/session';
  static const profile = '/main/profile';
  static const accountInformation = '/accountInformation';
  static const appearances = '/appearances';
  static const settings = '/settings';
  static const stats = '/stats';
}

sealed class AppDestination {
  const AppDestination();
  String get location;

  void go(BuildContext context) => context.go(location);
  Future<T?> push<T>(BuildContext context, {Object? extra}) =>
      context.push<T>(location, extra: extra);
}

enum MainTabDestination implements AppDestination {
  vocabulary(Routes.vocabulary, 0),
  explore(Routes.explore, 1),
  home(Routes.home, 2),
  workout(Routes.workout, 3),
  profile(Routes.profile, 4);

  const MainTabDestination(this.location, this.tabIndex);

  @override
  final String location;
  final int tabIndex;

  @override
  void go(BuildContext context) => context.go(location);

  @override
  Future<T?> push<T>(BuildContext context, {Object? extra}) =>
      context.push<T>(location, extra: extra);

  static MainTabDestination fromLocation(String location) {
    if (location == Routes.library) return vocabulary;
    if (location.startsWith('${Routes.main}/module/')) return explore;
    return values.firstWhere(
      (tab) =>
          location == tab.location || location.startsWith('${tab.location}/'),
      orElse: () => home,
    );
  }
}

class VocabularyDestination extends AppDestination {
  const VocabularyDestination(this.entryId);
  final String entryId;

  @override
  String get location => '${Routes.vocabulary}/$entryId';
}

class ModuleDestination extends AppDestination {
  const ModuleDestination(this.moduleId);
  final String moduleId;

  @override
  String get location => '${Routes.main}/module/$moduleId';
}

class LessonDestination extends AppDestination {
  const LessonDestination(this.moduleId, this.lessonId);
  final String moduleId;
  final String lessonId;

  @override
  String get location => '${Routes.main}/module/$moduleId/lesson/$lessonId';
}
