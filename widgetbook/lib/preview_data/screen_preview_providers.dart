import 'dart:async';

import 'package:flutter/widgets.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/ui/state/learn_state.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/ui/state/profile_state.dart';
import 'package:forge_dance/features/profile/ui/view_model/profile_view_model.dart';
import 'package:forge_dance/features/stats/model/user_stats.dart';
import 'package:forge_dance/features/stats/ui/view_model/user_stats_provider.dart';

const previewStats = UserStats(
  totalXp: 1720,
  streakCount: 12,
  level: 8,
  beltName: 'Blue',
  xpIntoLevel: 720,
  xpForLevelSpan: 1000,
  nextLevelXp: 2000,
  levelProgress: 0.72,
);

const previewProfile = Profile(
  id: 'widgetbook-dancer',
  email: 'dancer@example.com',
  name: 'Alex Rivera',
  job: 'Dance student',
  xp: 1720,
  streakCount: 12,
  lastActivityDate: '2026-08-21',
);

enum PreviewLearnCondition { loaded, loading, error }

Widget buildHomePreview({
  required Widget child,
  required PreviewLearnCondition condition,
}) {
  return ProviderScope(
    overrides: [
      learnViewModelProvider.overrideWith(
        () => _PreviewLearnViewModel(condition),
      ),
      profileViewModelProvider.overrideWith(_PreviewProfileViewModel.new),
      userStatsProvider.overrideWith((ref) => previewStats),
    ],
    child: child,
  );
}

enum PreviewStatsCondition { loaded, loading, error }

Widget buildStatsPreview({
  required Widget child,
  required PreviewStatsCondition condition,
}) {
  return ProviderScope(
    overrides: [
      userStatsProvider.overrideWith(
        (ref) => switch (condition) {
          PreviewStatsCondition.loaded => previewStats,
          PreviewStatsCondition.loading => Completer<UserStats>().future,
          PreviewStatsCondition.error => Future<UserStats>.error(
            StateError('Widgetbook preview error'),
          ),
        },
      ),
    ],
    child: child,
  );
}

class _PreviewLearnViewModel extends LearnViewModel {
  _PreviewLearnViewModel(this.condition);

  final PreviewLearnCondition condition;

  @override
  FutureOr<LearnState> build() {
    return switch (condition) {
      PreviewLearnCondition.loaded => _previewLearnState(),
      PreviewLearnCondition.loading => Completer<LearnState>().future,
      PreviewLearnCondition.error => Future<LearnState>.error(
        StateError('Widgetbook preview error'),
      ),
    };
  }
}

class _PreviewProfileViewModel extends ProfileViewModel {
  @override
  FutureOr<ProfileState> build() => const ProfileState(profile: previewProfile);
}

LearnState _previewLearnState() {
  final module = allModules.first;
  final lessons = module.lessons;
  return LearnState(
    modules: allModules,
    activeModuleId: module.id,
    progress: {
      lessons.first.id: LessonProgress(
        lessonId: lessons.first.id,
        status: LessonStatus.completed,
        progress: 1,
        completedDate: '2026-08-20',
        awardedXp: 100,
      ),
      lessons[1].id: LessonProgress(
        lessonId: lessons[1].id,
        status: LessonStatus.inProgress,
        progress: 0.45,
      ),
    },
  );
}
