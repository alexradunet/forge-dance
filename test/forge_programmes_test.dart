import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/ui/state/learn_state.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/method/repository/method_catalog.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/repository/practice_repository.dart';
import 'package:forge_dance/features/practice/ui/practice_view_model.dart';
import 'package:forge_dance/features/programmes/repository/programme_catalog.dart';
import 'package:forge_dance/features/programmes/repository/programme_repository.dart';
import 'package:forge_dance/features/programmes/ui/programmes_view_model.dart';
import 'package:forge_dance/features/vocabulary/model/vocabulary_learning.dart';
import 'package:forge_dance/features/vocabulary/repository/vocabulary_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

LearnState _learning([Map<String, LessonProgress> progress = const {}]) =>
    LearnState(
      modules: allModules,
      activeModuleId: allModules.first.id,
      progress: progress,
    );

LessonProgress _completed(String id) =>
    LessonProgress(lessonId: id, status: LessonStatus.completed, progress: 1);

PracticeRecord _record(String id, String vocabularyId, DateTime performedAt) {
  final block = const VocabularyRepository().practiceFor(
    const VocabularyRepository().byId(vocabularyId)!,
  );
  return PracticeRecord(
    id: id,
    blockId: block.id,
    title: block.title,
    lessonId: block.lessonId,
    vocabularyId: vocabularyId,
    category: block.category,
    level: block.level,
    performedAt: performedAt,
    durationSeconds: 45,
    bpm: block.bpm,
    attempts: 2,
    difficulty: 3,
    notes: 'Kept the return controlled.',
  );
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'each curated schedule is traversable using the existing lesson locks',
    () {
      for (final programme in forgeProgrammes) {
        var learning = _learning();
        // Walk the real prerequisite path; never seed impossible completion states.
        for (final lesson in allModules.expand((module) => module.lessons)) {
          if (programme.unmetPrerequisites(learning).isEmpty) break;
          expect(learning.canOpenLesson(lesson.id), isTrue);
          learning = learning.copyWith(
            progress: {...learning.progress, lesson.id: _completed(lesson.id)},
          );
        }
        expect(programme.unmetPrerequisites(learning), isEmpty);
        for (final session in programme.sessions) {
          expect(
            learning.canOpenLesson(session.lessonId),
            isTrue,
            reason: '${programme.id}: ${session.lessonId}',
          );
          expect(session.practice.lessonId, session.lessonId);
          learning = learning.copyWith(
            progress: {
              ...learning.progress,
              session.lessonId: _completed(session.lessonId),
            },
          );
        }
        expect(
          programme.completedSessions(learning),
          programme.sessions.length,
        );
        expect(programme.nextSession(learning), isNull);
        final assessment = forgeAssessments.singleWhere(
          (item) => item.id == programme.assessmentId,
        );
        expect(learning.canOpenLesson(assessment.linkedLessonId), isTrue);
      }
    },
  );

  test(
    'enrolment rejects unmet prerequisites and does not complete any lesson',
    () async {
      final container = ProviderContainer();
      addTearDown(container.dispose);
      container.listen(learnViewModelProvider, (_, _) {});
      container.listen(programmesViewModelProvider, (_, _) {});
      await container.read(learnViewModelProvider.future);
      await container.read(programmesViewModelProvider.future);
      final notifier = container.read(programmesViewModelProvider.notifier);
      await expectLater(notifier.enrol('first-freestyle'), throwsStateError);
      await notifier.enrol('find-the-beat');
      expect(await ProgrammeRepository().getEnrolledIds(), {'find-the-beat'});
      expect(
        container.read(learnViewModelProvider).requireValue.progress,
        isEmpty,
      );
      expect(
        forgeProgrammes.first.completedSessions(
          container.read(learnViewModelProvider).requireValue,
        ),
        0,
      );
    },
  );

  test('concurrent enrolments survive restart and leaving preserves other enrolments', () async {
    final repository = ProgrammeRepository();
    await Future.wait([
      repository.enrol('find-the-beat'),
      ProgrammeRepository().enrol('movement-foundations'),
    ]);
    final reopened = ProgrammeRepository();
    expect(await reopened.getEnrolledIds(), {
      'find-the-beat',
      'movement-foundations',
    });
    await reopened.leave('find-the-beat');
    expect(await ProgrammeRepository().exportJson(), ['movement-foundations']);
  });

  test(
    'invalid enrolment import is atomic and a later valid write still works',
    () async {
      final repository = ProgrammeRepository();
      await repository.enrol('find-the-beat');
      expect(
        () => repository.replaceFromJson(['movement-foundations', 'missing']),
        throwsFormatException,
      );
      expect(
        () => repository.replaceFromJson(['find-the-beat', 'find-the-beat']),
        throwsFormatException,
      );
      expect(await repository.exportJson(), ['find-the-beat']);
      await repository.replaceFromJson(['dance-endurance']);
      expect(await ProgrammeRepository().exportJson(), ['dance-endurance']);
    },
  );

  test('a failed storage write is surfaced without losing enrollment or poisoning retry', () async {
    String? stored;
    var failWrites = false;
    final repository = ProgrammeRepository(
      readString: (_) async => stored,
      writeString: (_, value) async {
        if (failWrites) return false;
        stored = value;
        return true;
      },
    );
    await repository.enrol('find-the-beat');
    failWrites = true;
    await expectLater(
      repository.enrol('movement-foundations'),
      throwsStateError,
    );
    expect(await repository.getEnrolledIds(), {'find-the-beat'});
    failWrites = false;
    await repository.enrol('movement-foundations');
    expect(await repository.getEnrolledIds(), {
      'find-the-beat',
      'movement-foundations',
    });
  });

  test(
    'studying and repeated practice never manufacture demonstrated capability',
    () {
      final entry = const VocabularyRepository().byId('pulse')!;
      final now = DateTime.utc(2026, 9, 7);
      final status = VocabularyLearning(
        entry: entry,
        lessons: {entry.lessonId: _completed(entry.lessonId)},
        method: MethodProgress(),
        practice: [
          _record('first', entry.id, now),
          _record('second', entry.id, now.add(const Duration(minutes: 5))),
        ],
      );
      expect(status.studied, isTrue);
      expect(status.categoryLevel, 0);
      expect(status.categoryAttempts, isEmpty);
      expect(status.practiceHistory.map((record) => record.id), [
        'second',
        'first',
      ]);
    },
  );

  test('failed category retest updates demonstration without erasing study or prior evidence', () {
    final entry = const VocabularyRepository().byId('pulse')!;
    final assessment = forgeAssessments.singleWhere(
      (item) => item.category == entry.category && item.level == 1,
    );
    final now = DateTime.utc(2025, 9, 7);
    final passed = AssessmentAttempt(
      id: 'pass',
      assessmentId: assessment.id,
      performedAt: now,
      metCriteriaIds: assessment.criteria
          .map((criterion) => criterion.id)
          .toList(),
    );
    final failed = AssessmentAttempt(
      id: 'retest',
      assessmentId: assessment.id,
      performedAt: now.add(const Duration(days: 1)),
      metCriteriaIds: [],
    );
    final status = VocabularyLearning(
      entry: entry,
      lessons: {entry.lessonId: _completed(entry.lessonId)},
      method: MethodProgress(attempts: [passed, failed]),
      practice: [],
    );
    expect(status.studied, isTrue);
    expect(status.categoryLevel, 0);
    expect(status.categoryAttempts.map((attempt) => attempt.passed), [
      false,
      true,
    ]);
  });

  test('vocabulary practice records persist through the shared VM and filter by term', () async {
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(practiceViewModelProvider.future);
    final now = DateTime.utc(2026, 9, 7);
    final notifier = container.read(practiceViewModelProvider.notifier);
    await notifier.record(_record('pulse-first', 'pulse', now));
    await notifier.record(
      _record('pulse-second', 'pulse', now.add(const Duration(minutes: 2))),
    );
    await notifier.record(_record('breath-first', 'breath', now));
    final stored = await PracticeRepository().getAll();
    final pulse = VocabularyLearning(
      entry: const VocabularyRepository().byId('pulse')!,
      lessons: {},
      method: MethodProgress(),
      practice: stored,
    );
    expect(pulse.practiceHistory.map((record) => record.id), [
      'pulse-second',
      'pulse-first',
    ]);
    expect(pulse.studied, isFalse);
    expect(pulse.categoryLevel, 0);
  });
}
