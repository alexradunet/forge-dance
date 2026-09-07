import 'package:flutter/foundation.dart';

import '../../learn/model/lesson_progress.dart';
import '../../learn/ui/state/learn_state.dart';
import '../../method/model/forge_method.dart';
import '../../practice/model/practice.dart';

@immutable
class ProgrammeSession {
  const ProgrammeSession({
    required this.lessonId,
    required this.schedule,
    required this.practice,
  });

  final String lessonId;
  final String schedule;
  final PracticeBlock practice;
}

/// A curated route through the lesson catalogue, not another completion store.
@immutable
class Programme {
  const Programme({
    required this.id,
    required this.title,
    required this.description,
    required this.schedule,
    required this.prerequisiteLessonIds,
    required this.intendedGains,
    required this.sessions,
    required this.assessmentId,
  });

  final String id;
  final String title;
  final String description;
  final String schedule;
  final List<String> prerequisiteLessonIds;
  final Map<ForgeCategory, String> intendedGains;
  final List<ProgrammeSession> sessions;
  final String assessmentId;

  List<String> unmetPrerequisites(LearnState learn) => [
    for (final id in prerequisiteLessonIds)
      if (learn.progress[id]?.status != LessonStatus.completed) id,
  ];

  int completedSessions(LearnState learn) => sessions
      .where(
        (session) =>
            learn.progress[session.lessonId]?.status == LessonStatus.completed,
      )
      .length;

  ProgrammeSession? nextSession(LearnState learn) => sessions
      .where(
        (session) =>
            learn.progress[session.lessonId]?.status != LessonStatus.completed,
      )
      .firstOrNull;
}
