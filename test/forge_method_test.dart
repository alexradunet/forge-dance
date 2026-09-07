import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/method/repository/method_catalog.dart';
import 'package:forge_dance/features/method/repository/method_repository.dart';
import 'package:forge_dance/features/method/ui/method_view_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

AssessmentAttempt attempt(
  String assessmentId,
  int sequence, {
  bool pass = true,
  String? id,
}) {
  final rubric = assessmentById(assessmentId);
  return AssessmentAttempt(
    id: id ?? 'attempt-$sequence',
    assessmentId: assessmentId,
    performedAt: DateTime.utc(2025, 1, 1).add(Duration(minutes: sequence)),
    metCriteriaIds: pass
        ? rubric.criteria.map((criterion) => criterion.id).toList()
        : [],
    notes: 'Observed the task using a supported base.',
  );
}

List<AssessmentAttempt> corePasses(int level) => [
  for (final category in ForgeCategory.values.where(
    (category) => category.isCore,
  ))
    attempt('${category.name}-$level-v1', category.index),
];

class FailingMethodRepository extends MethodRepository {
  bool failNextWrite = false;
  @override
  Future<MethodProgress> recordAssessment(AssessmentAttempt attempt) {
    if (failNextWrite) {
      failNextWrite = false;
      return Future.error(StateError('Device storage unavailable'));
    }
    return super.recordAssessment(attempt);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('unassessed, support-only and six core passes cannot invent a belt', () {
    final empty = MethodProgress();
    expect(empty.earnedBeltIndex, 0);
    expect(empty.nextBeltProgress, 0);
    expect(ForgeCategory.values.map(empty.levelFor), everyElement(0));
    final support = MethodProgress(
      attempts: [attempt('mobility-7-v1', 0), attempt('capacity-7-v1', 1)],
    );
    expect(support.earnedBeltIndex, 0);
    expect(support.nextBeltProgress, 0);
    final core = MethodProgress(attempts: corePasses(1));
    expect(core.earnedBeltIndex, 0);
    expect(core.nextBeltProgress, closeTo(6 / 7, 0.00001));
  });

  test('all core categories and integrated proof earn a dated belt without physical gates', () {
    final attempts = [...corePasses(1), attempt('integrated-1-v1', 6)];
    final progress = MethodProgress(attempts: attempts);
    expect(progress.earnedBeltIndex, 1);
    expect(progress.awards.single.awardedAt, attempts.last.performedAt);
    expect(progress.awards.single.evidenceIds, attempts.map((item) => item.id));
    expect(progress.levelFor(ForgeCategory.capacity), 0);
    expect(
      progress.requirementsForBelt(1).map((item) => item.isMet),
      everyElement(true),
    );
  });

  test('a strong average cannot compensate for one missing category', () {
    final attempts = corePasses(7)
      ..removeWhere(
        (item) => item.assessment.category == ForgeCategory.retention,
      );
    attempts.add(attempt('integrated-7-v1', 6));
    expect(MethodProgress(attempts: attempts).earnedBeltIndex, 0);
    attempts.add(attempt('retention-1-v1', 7));
    expect(MethodProgress(attempts: attempts).earnedBeltIndex, 1);
  });

  test(
    'failed retests lower capability but preserve historical awards on reload',
    () {
      final attempts = [
        ...corePasses(1),
        attempt('integrated-1-v1', 6),
        attempt('rhythm-2-v1', 7),
        attempt('rhythm-2-v1', 8, pass: false),
      ];
      final progress = MethodProgress(attempts: attempts);
      expect(progress.levelFor(ForgeCategory.rhythm), 1);
      expect(progress.earnedBeltIndex, 1);
      attempts.add(attempt('rhythm-1-v1', 9, pass: false));
      final restored = MethodProgress.fromJson(
        jsonDecode(jsonEncode(MethodProgress(attempts: attempts).toJson()))
            as Map<String, Object?>,
      );
      expect(restored.levelFor(ForgeCategory.rhythm), 0);
      expect(restored.earnedBeltIndex, 1);
      expect(
        restored.awards.single.evidenceIds,
        progress.awards.single.evidenceIds,
      );
      expect(restored.attempts.length, attempts.length);
    },
  );

  test('failed history is never resurrected by later lower-level retests', () {
    final progress = MethodProgress(
      attempts: [
        attempt('rhythm-1-v1', 0),
        attempt('rhythm-2-v1', 1),
        attempt('rhythm-1-v1', 2, pass: false),
        attempt('rhythm-3-v1', 3),
        attempt('rhythm-3-v1', 4, pass: false),
      ],
    );
    expect(progress.levelFor(ForgeCategory.rhythm), 0);
  });

  test('unknown criteria, rubric versions and forged awards are rejected', () {
    final original = attempt('rhythm-1-v1', 0).toJson();
    expect(
      () => AssessmentAttempt.fromJson({
        ...original,
        'metCriteriaIds': ['task', 'repeat', 'safe', 'bonus'],
      }),
      throwsFormatException,
    );
    expect(
      () => AssessmentAttempt.fromJson({
        ...original,
        'metCriteriaIds': ['task', 'task', 'safe'],
      }),
      throwsFormatException,
    );
    expect(
      () => AssessmentAttempt.fromJson({...original, 'rubricVersion': 99}),
      throwsFormatException,
    );
    expect(
      () =>
          AssessmentAttempt.fromJson({...original, 'assessmentId': 'unknown'}),
      throwsFormatException,
    );
    final forged = MethodProgress().toJson();
    forged['awards'] = [
      BeltAward(
        index: 7,
        awardedAt: DateTime.utc(2025),
        evidenceIds: [],
      ).toJson(),
    ];
    expect(() => MethodProgress.fromJson(forged), throwsFormatException);
  });

  test(
    'published rubrics cover every level and link to actual learning content',
    () {
      final lessonIds = allModules
          .expand((module) => module.lessons)
          .map((lesson) => lesson.id)
          .toSet();
      for (final category in ForgeCategory.values) {
        for (var level = 1; level <= 7; level++) {
          final rubric = assessmentById('${category.name}-$level-v1');
          expect(rubric.category, category);
          expect(lessonIds, contains(rubric.linkedLessonId));
          expect(rubric.isPassedBy(attempt(rubric.id, 0)), isTrue);
          final partial = attempt(rubric.id, 0).toJson()
            ..['metCriteriaIds'] = ['task', 'repeat'];
          expect(
            rubric.isPassedBy(AssessmentAttempt.fromJson(partial)),
            isFalse,
          );
        }
      }
      for (final belt in forgeBelts.skip(1)) {
        final integrated = assessmentById(belt.integratedAssessmentId!);
        expect(integrated.category, isNull);
        expect(integrated.level, belt.requiredLevel);
        expect(lessonIds, contains(integrated.linkedLessonId));
      }
    },
  );

  test('serialized appends retain repeats, retries are idempotent and failed imports do not mutate', () async {
    SharedPreferences.setMockInitialValues({});
    final repository = MethodRepository();
    final first = attempt('rhythm-1-v1', 0);
    final second = attempt('rhythm-1-v1', 1);
    await Future.wait([
      repository.recordAssessment(first),
      MethodRepository().recordAssessment(second),
    ]);
    await repository.recordAssessment(first);
    expect((await MethodRepository().get()).attempts.map((item) => item.id), [
      first.id,
      second.id,
    ]);
    await expectLater(
      repository.recordAssessment(
        attempt('rhythm-1-v1', 0, pass: false, id: first.id),
      ),
      throwsFormatException,
    );
    await repository.recordAssessment(attempt('rhythm-2-v1', 2));
    expect(
      () => repository.replaceFromJson({'schemaVersion': 999}),
      throwsFormatException,
    );
    expect((await repository.get()).levelFor(ForgeCategory.rhythm), 2);
  });

  test(
    'view model publishes persisted outcomes and reloads exact history',
    () async {
      SharedPreferences.setMockInitialValues({});
      final container = ProviderContainer();
      addTearDown(container.dispose);
      await container.read(methodViewModelProvider.future);
      final notifier = container.read(methodViewModelProvider.notifier);
      await notifier.recordAssessment(attempt('rhythm-1-v1', 0));
      await notifier.recordAssessment(attempt('rhythm-1-v1', 1, pass: false));
      await notifier.reload();
      final progress = container.read(methodViewModelProvider).requireValue;
      expect(progress.levelFor(ForgeCategory.rhythm), 0);
      expect(progress.attempts.map((item) => item.passed), [true, false]);
      expect((await MethodRepository().get()).toJson(), progress.toJson());
    },
  );

  test(
    'failed persistence cannot publish a belt, and retry can earn it once',
    () async {
      SharedPreferences.setMockInitialValues({});
      final repository = FailingMethodRepository();
      final container = ProviderContainer(
        overrides: [methodRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(methodViewModelProvider.future);
      final notifier = container.read(methodViewModelProvider.notifier);
      for (final evidence in corePasses(1)) {
        await notifier.recordAssessment(evidence);
      }
      repository.failNextWrite = true;
      final integrated = attempt('integrated-1-v1', 6);
      await expectLater(
        notifier.recordAssessment(integrated),
        throwsStateError,
      );
      expect(
        container.read(methodViewModelProvider).requireValue.earnedBeltIndex,
        0,
      );
      expect((await repository.get()).earnedBeltIndex, 0);
      await notifier.recordAssessment(integrated);
      await notifier.recordAssessment(integrated);
      expect(
        container
            .read(methodViewModelProvider)
            .requireValue
            .awards
            .map((award) => award.index),
        [1],
      );
      expect(
        (await repository.get()).attempts
            .where((item) => item.id == integrated.id)
            .single
            .passed,
        isTrue,
      );
    },
  );

  test(
    'integrated and delayed recall passes require their written observations',
    () {
      for (final id in [
        'integrated-1-v1',
        'retention-6-v1',
        'retention-7-v1',
      ]) {
        final withoutNotes = AssessmentAttempt.fromJson({
          ...attempt(id, 0).toJson(),
          'notes': '',
        });
        expect(withoutNotes.passed, isFalse);
        expect(attempt(id, 0).passed, isTrue);
      }
    },
  );
}
