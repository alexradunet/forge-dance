import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forge_dance/constants/constants.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/method/repository/method_catalog.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/repository/practice_planner.dart';
import 'package:forge_dance/features/practice/repository/practice_repository.dart';
import 'package:forge_dance/features/practice/ui/practice_view_model.dart';

MethodProgress _progress(Map<ForgeCategory, int> levels) => MethodProgress(
  attempts: [
    for (final entry in levels.entries)
      AssessmentAttempt(
        id: 'pass-${entry.key.name}',
        assessmentId: '${entry.key.name}-${entry.value}-v1',
        performedAt: DateTime.utc(2026, 9, 7),
        metCriteriaIds: forgeAssessments
            .firstWhere(
              (assessment) =>
                  assessment.category == entry.key &&
                  assessment.level == entry.value,
            )
            .criteria
            .map((criterion) => criterion.id)
            .toList(),
      ),
  ],
);

PracticeRecord _record(
  String id, {
  int bpm = 80,
  int level = 2,
  int duration = 90,
}) => PracticeRecord(
  id: id,
  blockId: 'rhythm-l2-standing-regular',
  title: 'Pulse · accents',
  lessonId: 'common-time-weight-find-pulse',
  category: ForgeCategory.rhythm,
  level: level,
  performedAt: DateTime.utc(2026, 9, 7, 12),
  durationSeconds: duration,
  bpm: bpm,
  attempts: 3,
  difficulty: 4,
  notes: 'Found the pulse after restarting.',
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));

  test(
    'mixed capability scales each category instead of using a belt or average',
    () {
      final levels = {
        ForgeCategory.rhythm: 5,
        ForgeCategory.bodyControl: 2,
        ForgeCategory.footwork: 3,
        ForgeCategory.coordination: 1,
        ForgeCategory.retention: 4,
        ForgeCategory.creativity: 2,
        ForgeCategory.mobility: 1,
        ForgeCategory.capacity: 3,
      };
      final plan = buildPracticePlan(
        progress: _progress(levels),
        minutes: 30,
        gentle: false,
        includeConditioning: true,
      );
      for (final block in plan.blocks) {
        expect(block.level, levels[block.category]);
      }
      expect(plan.blocks.first.category, ForgeCategory.mobility);
      expect(plan.blocks.last.category, ForgeCategory.mobility);
      expect(plan.minutes, 30);
    },
  );

  test('unassessed work is beginner-labelled and all links resolve to real lessons', () {
    final plan = buildPracticePlan(
      progress: MethodProgress(),
      minutes: 10,
      gentle: false,
      includeConditioning: false,
      support: PracticeSupport.seated,
    );
    final lessonIds = allModules
        .expand((module) => module.lessons)
        .map((lesson) => lesson.id)
        .toSet();
    for (final block in plan.blocks) {
      expect(block.level, 1);
      expect(block.adaptation, contains('Not assessed'));
      expect(block.adaptation, contains('remain seated'));
      expect(lessonIds, contains(block.lessonId));
    }
    expect(
      plan.blocks.any((block) => block.category == ForgeCategory.capacity),
      isFalse,
    );
    expect(plan.minutes, 10);
  });

  test('time budgets preserve recovery and gentle work changes complexity without regrading', () {
    final progress = _progress({
      ForgeCategory.rhythm: 6,
      ForgeCategory.bodyControl: 1,
    });
    for (final minutes in [10, 11, 20, 60]) {
      final plan = buildPracticePlan(
        progress: progress,
        minutes: minutes,
        gentle: true,
        includeConditioning: true,
        support: PracticeSupport.supported,
      );
      expect(plan.minutes, minutes);
      expect(plan.blocks.every((block) => block.minutes > 0), isTrue);
      expect(plan.blocks.first.category, ForgeCategory.mobility);
      expect(plan.blocks.last.category, ForgeCategory.mobility);
      expect(
        plan.blocks
            .singleWhere((block) => block.category == ForgeCategory.rhythm)
            .level,
        5,
      );
      expect(
        plan.blocks
            .singleWhere((block) => block.category == ForgeCategory.bodyControl)
            .level,
        1,
      );
    }
    expect(progress.levelFor(ForgeCategory.rhythm), 6);
    expect(
      () => buildPracticePlan(
        progress: progress,
        minutes: 9,
        gentle: false,
        includeConditioning: true,
      ),
      throwsArgumentError,
    );
  });

  test('concurrent same-day repeats survive a fresh repository and retry is idempotent', () async {
    final first = _record(PracticeRecord.createId());
    final second = _record(PracticeRecord.createId());
    await Future.wait([
      PracticeRepository().record(first),
      PracticeRepository().record(second),
      PracticeRepository().record(first),
    ]);
    final restored = await PracticeRepository().getAll();
    expect(
      restored.map((record) => record.id),
      unorderedEquals([first.id, second.id]),
    );
    expect(
      restored.map((record) => record.toJson()),
      unorderedEquals([first.toJson(), second.toJson()]),
    );
  });

  test('a conflicting ID cannot overwrite an earlier result', () async {
    final repository = PracticeRepository();
    await repository.record(_record('one'));
    await expectLater(
      repository.record(_record('one', duration: 180)),
      throwsStateError,
    );
    expect((await repository.getAll()).single.durationSeconds, 90);
  });

  test(
    'failed storage is observable and does not poison later retry or append',
    () async {
      final store = <String, String>{};
      var fail = true;
      final repository = PracticeRepository(
        readString: (key) async => store[key],
        writeString: (key, value) async {
          if (fail) return false;
          store[key] = value;
          return true;
        },
      );
      await expectLater(repository.record(_record('one')), throwsStateError);
      expect(await repository.getAll(), isEmpty);
      fail = false;
      await repository.record(_record('one'));
      await repository.record(_record('two'));
      expect((await repository.getAll()).map((record) => record.id), [
        'one',
        'two',
      ]);
    },
  );

  test('invalid import is atomic and corrupted storage is never replaced by an empty log', () async {
    final repository = PracticeRepository();
    await repository.record(_record('kept'));
    expect(
      () => repository.replaceFromJson([
        _record('incoming').toJson(),
        {..._record('bad').toJson(), 'difficulty': 11},
      ]),
      throwsFormatException,
    );
    expect(
      () => repository.replaceFromJson([
        _record('duplicate').toJson(),
        _record('duplicate').toJson(),
      ]),
      throwsFormatException,
    );
    expect((await repository.getAll()).single.id, 'kept');
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(Constants.practiceRecordsKey, '{broken');
    await expectLater(repository.record(_record('new')), throwsFormatException);
    expect(preferences.getString(Constants.practiceRecordsKey), '{broken');
  });

  test('reflection edits preserve measured data and deleting one repeat preserves the other', () async {
    final repository = PracticeRepository();
    final first = _record('one');
    await repository.record(first);
    await repository.record(_record('two'));
    await repository.updateReflection(
      first.withReflection(
        notes: 'A smaller gesture helped.',
        difficulty: 3,
        evidenceId: 'private-clip',
      ),
    );
    final edited = (await repository.getAll()).first;
    expect(edited.notes, 'A smaller gesture helped.');
    expect(edited.evidenceId, 'private-clip');
    expect(edited.durationSeconds, 90);
    await expectLater(
      repository.updateReflection(_record('one', duration: 180)),
      throwsStateError,
    );
    await repository.delete('one');
    expect((await repository.getAll()).single.id, 'two');
  });

  test('comparable history excludes different tempo and level, not different effort or duration', () {
    final first = _record('one');
    expect(first.isComparableTo(_record('two', duration: 150)), isTrue);
    expect(first.isComparableTo(_record('three', bpm: 100)), isFalse);
    expect(first.isComparableTo(_record('four', level: 3)), isFalse);
    expect(
      first.isComparableTo(
        first.withReflection(notes: '', difficulty: 8, evidenceId: null),
      ),
      isTrue,
    );
  });

  test(
    'choices survive restart and portable import rejects unsupported positions',
    () async {
      final repository = PracticeRepository();
      const choices = PracticePreferences(
        minutes: 45,
        gentle: true,
        includeConditioning: true,
        support: PracticeSupport.seated,
      );
      await repository.savePreferences(choices);
      expect(
        (await PracticeRepository().getPreferences()).toJson(),
        choices.toJson(),
      );
      expect(
        () => repository.replacePreferencesFromJson({
          ...choices.toJson(),
          'support': 'unsafe',
        }),
        throwsFormatException,
      );
      expect((await repository.getPreferences()).toJson(), choices.toJson());
      await repository.replaceFromJson(
        jsonDecode(jsonEncode([_record('imported').toJson()])) as List<Object?>,
      );
      expect((await PracticeRepository().getAll()).single.id, 'imported');
    },
  );

  test(
    'view model exposes write failure and can recover with the same result',
    () async {
      var fail = true;
      final storage = <String, String>{};
      final repository = PracticeRepository(
        readString: (key) async => storage[key],
        writeString: (key, value) async {
          if (fail) throw StateError('Disk unavailable');
          storage[key] = value;
          return true;
        },
      );
      final container = ProviderContainer(
        overrides: [practiceRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(practiceViewModelProvider.future);
      final notifier = container.read(practiceViewModelProvider.notifier);
      await expectLater(notifier.record(_record('one')), throwsStateError);
      expect(container.read(practiceViewModelProvider).hasError, isTrue);
      fail = false;
      await notifier.record(_record('one'));
      expect(
        container.read(practiceViewModelProvider).requireValue.single.id,
        'one',
      );
    },
  );
}
