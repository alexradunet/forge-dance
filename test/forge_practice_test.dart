import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forge_dance/constants/constants.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/method/model/forge_method.dart';
import 'package:forge_dance/features/method/repository/method_catalog.dart';
import 'package:forge_dance/features/practice/model/practice.dart';
import 'package:forge_dance/features/practice/repository/daily_practice_catalog.dart';
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

MethodProgress _beltProgress(int belt) => MethodProgress(
  attempts: belt == 0
      ? []
      : [
          for (final assessment in forgeAssessments.where(
            (assessment) =>
                assessment.level == belt &&
                (assessment.category == null || assessment.category!.isCore),
          ))
            AssessmentAttempt(
              id: 'pass-${assessment.id}',
              assessmentId: assessment.id,
              performedAt: DateTime.utc(2026, 1, 1),
              notes: 'Recalled the complete phrase and explained the chosen adaptations.',
              metCriteriaIds: assessment.criteria
                  .map((value) => value.id)
                  .toList(),
            ),
        ],
);

PracticePlan _dailyPlan({
  DateTime? date,
  int belt = 0,
  int minutes = 20,
  bool gentle = false,
  bool conditioning = false,
  PracticeSupport support = PracticeSupport.standing,
}) => buildPracticePlan(
  date: date ?? DateTime.utc(2026, 1, 1),
  progress: _beltProgress(belt),
  minutes: minutes,
  gentle: gentle,
  includeConditioning: conditioning,
  support: support,
);

PracticeRecord _dailyRecord(String id, PracticeBlock block) => PracticeRecord(
  id: id,
  blockId: block.id,
  workoutId: block.workoutId,
  workoutDate: block.workoutDate,
  title: block.title,
  lessonId: block.lessonId,
  category: block.category,
  level: block.level,
  performedAt: DateTime.utc(2026, 9, 7, 12),
  durationSeconds: 90,
  bpm: block.bpm,
  attempts: 2,
  difficulty: 3,
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
    'a civil date shares one workout across belts, times and preferences',
    () {
      final white = _dailyPlan(date: DateTime(2026, 9, 7));
      final black = _dailyPlan(
        date: DateTime.utc(2026, 9, 7, 23, 59),
        belt: 7,
        minutes: 45,
        support: PracticeSupport.seated,
        conditioning: true,
      );
      expect(black.workoutId, white.workoutId);
      expect(black.title, white.title);
      expect(black.focus, white.focus);
      expect(black.dateKey, '2026-09-07');
      expect(white.dateKey, black.dateKey);
      expect(white.blocks[1].level, 0);
      expect(black.blocks[1].level, 7);
      expect(white.blocks[1].cues, isNot(black.blocks[1].cues));
      expect(white.blocks[2].cues, isNot(black.blocks[2].cues));
      for (final block in [...white.blocks, ...black.blocks]) {
        expect(block.workoutId, white.workoutId);
        expect(block.workoutDate, white.dateKey);
      }
    },
  );

  test('rotation continues through years, leap days and DST civil dates', () {
    expect(
      dailyPracticeThemeFor(DateTime.utc(2026, 1, 1)).id,
      dailyPracticeThemes.first.id,
    );
    expect(
      dailyPracticeThemeFor(DateTime.utc(2025, 12, 31)).id,
      dailyPracticeThemes.last.id,
    );
    expect(
      dailyPracticeThemeFor(DateTime.utc(2027, 1, 1)).id,
      dailyPracticeThemes[365 % dailyPracticeThemes.length].id,
    );
    for (final dates in [
      [DateTime(2026, 12, 31), DateTime(2027, 1, 1)],
      [DateTime(2028, 2, 28), DateTime(2028, 2, 29), DateTime(2028, 3, 1)],
      [DateTime(2026, 3, 28), DateTime(2026, 3, 29), DateTime(2026, 3, 30)],
      [DateTime(2026, 10, 24), DateTime(2026, 10, 25), DateTime(2026, 10, 26)],
    ]) {
      for (var i = 0; i < dates.length; i++) {
        final date = dates[i];
        final theme = dailyPracticeThemeFor(date);
        expect(
          dailyPracticeThemeFor(
            DateTime(date.year, date.month, date.day, 23, 59),
          ).id,
          theme.id,
        );
        expect(
          dailyPracticeThemeFor(DateTime.utc(date.year, date.month, date.day))
              .id,
          theme.id,
        );
        if (i > 0) {
          final previous = dailyPracticeThemes.indexOf(
            dailyPracticeThemeFor(dates[i - 1]),
          );
          expect(
            theme.id,
            dailyPracticeThemes[(previous + 1) % dailyPracticeThemes.length].id,
          );
        }
      }
    }
  });

  test(
    'earned belt governs the variation, not stronger individual categories',
    () {
      final mixed = _progress({
        ForgeCategory.rhythm: 7,
        ForgeCategory.bodyControl: 5,
        ForgeCategory.footwork: 4,
      });
      final beginner = buildPracticePlan(
        date: DateTime.utc(2026, 1, 1),
        progress: mixed,
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      );
      expect(beginner.beltIndex, 0);
      expect(beginner.blocks[1].level, 0);
      final earned = _beltProgress(4);
      final afterRetest = MethodProgress(
        attempts: [
          ...earned.attempts,
          AssessmentAttempt(
            id: 'failed-rhythm-retest',
            assessmentId: 'rhythm-4-v1',
            performedAt: DateTime.utc(2026, 1, 2),
            metCriteriaIds: const [],
          ),
        ],
      );
      expect(afterRetest.levelFor(ForgeCategory.rhythm), 0);
      final retained = buildPracticePlan(
        date: DateTime.utc(2026, 1, 1),
        progress: afterRetest,
        minutes: 20,
        gentle: false,
        includeConditioning: false,
      );
      expect(retained.beltIndex, 4);
      expect(retained.blocks[1].level, 4);
    },
  );

  test(
    'every theme has distinct White-to-Black work with real lesson links',
    () {
      final lessonIds = allModules
          .expand((module) => module.lessons)
          .map((lesson) => lesson.id)
          .toSet();
      expect(
        dailyPracticeThemes.map((theme) => theme.category).toSet(),
        containsAll(ForgeCategory.values.where((category) => category.isCore)),
      );
      for (var day = 0; day < dailyPracticeThemes.length; day++) {
        final theme = dailyPracticeThemes[day];
        final drillCues = <String>{};
        final applicationCues = <String>{};
        for (var belt = 0; belt <= 7; belt++) {
          final plan = _dailyPlan(
            date: DateTime.utc(2026, 1, 1 + day),
            belt: belt,
            conditioning: true,
          );
          expect(plan.beltIndex, belt);
          expect(plan.workoutId, theme.id);
          expect(plan.blocks.map((block) => block.category), [
            ForgeCategory.mobility,
            theme.category,
            theme.category,
            ForgeCategory.capacity,
            ForgeCategory.mobility,
          ]);
          for (final block in plan.blocks) {
            expect(block.level, belt);
            expect(block.workoutId, theme.id);
            expect(block.workoutDate, plan.dateKey);
            expect(lessonIds, contains(block.lessonId));
          }
          // Same support and tempo: a distinct instructional task must be authored,
          // not just a new label, faster metronome or a changed belt number.
          expect(drillCues.add(plan.blocks[1].cues.join('\n')), isTrue);
          expect(applicationCues.add(plan.blocks[2].cues.join('\n')), isTrue);
        }
      }
    },
  );

  test(
    'gentle lowers complexity without changing earned belt or daily theme',
    () {
      for (var day = 0; day < dailyPracticeThemes.length; day++) {
        for (var belt = 0; belt <= 7; belt++) {
          final date = DateTime.utc(2026, 1, 1 + day);
          final regular = _dailyPlan(date: date, belt: belt);
          final gentle = _dailyPlan(date: date, belt: belt, gentle: true);
          final lower = _dailyPlan(date: date, belt: belt == 0 ? 0 : belt - 1);
          expect(gentle.beltIndex, belt);
          expect(gentle.workoutId, regular.workoutId);
          expect(gentle.blocks[1].level, lower.blocks[1].level);
          expect(gentle.blocks[1].title, lower.blocks[1].title);
          expect(gentle.blocks[1].cues, containsAll(lower.blocks[1].cues));
          expect(gentle.blocks[2].cues, containsAll(lower.blocks[2].cues));
          expect(gentle.blocks[1].bpm, lessThan(regular.blocks[1].bpm));
        }
      }
    },
  );

  test(
    'support changes instructions and comparison identity, not the theme',
    () {
      for (var day = 0; day < dailyPracticeThemes.length; day++) {
        final date = DateTime.utc(2026, 1, 1 + day);
        final standing = _dailyPlan(date: date, belt: 4);
        for (final support in [
          PracticeSupport.seated,
          PracticeSupport.supported,
        ]) {
          final adapted = _dailyPlan(date: date, belt: 4, support: support);
          expect(adapted.workoutId, standing.workoutId);
          expect(adapted.beltIndex, standing.beltIndex);
          expect(adapted.blocks[1].title, standing.blocks[1].title);
          for (var i = 0; i < standing.blocks.length; i++) {
            expect(
              adapted.blocks[i].adaptation,
              isNot(standing.blocks[i].adaptation),
            );
            expect(adapted.blocks[i].cues, isNot(standing.blocks[i].cues));
            expect(adapted.blocks[i].id, isNot(standing.blocks[i].id));
          }
        }
      }
    },
  );

  test(
    'every allowed duration is exact with recovery and optional conditioning',
    () {
      for (var minutes = 10; minutes <= 60; minutes++) {
        for (final conditioning in [false, true]) {
          final plan = _dailyPlan(minutes: minutes, conditioning: conditioning);
          expect(plan.minutes, minutes);
          expect(plan.blocks.every((block) => block.minutes > 0), isTrue);
          expect(plan.blocks.first.category, ForgeCategory.mobility);
          expect(plan.blocks.last.category, ForgeCategory.mobility);
          expect(
            plan.blocks
                .where((block) => block.category == ForgeCategory.capacity)
                .length,
            conditioning ? 1 : 0,
          );
        }
      }
      for (final minutes in [9, 61]) {
        expect(() => _dailyPlan(minutes: minutes), throwsArgumentError);
      }
    },
  );

  test(
    'White daily records survive portable import, restart and reflection edits',
    () async {
      final plan = _dailyPlan(date: DateTime.utc(2028, 2, 29));
      final result = _dailyRecord('daily-white', plan.blocks[1]);
      final repository = PracticeRepository();
      await repository.replaceFromJson(
        jsonDecode(jsonEncode([result.toJson()])) as List<Object?>,
      );
      final restored = (await PracticeRepository().getAll()).single;
      expect(restored.level, 0);
      expect(restored.workoutId, plan.workoutId);
      expect(restored.workoutDate, '2028-02-29');
      expect(restored.toJson(), result.toJson());
      await repository.updateReflection(
        restored.withReflection(
          notes: 'A smaller gesture made the pattern clear.',
          difficulty: 2,
          evidenceId: null,
        ),
      );
      final edited = (await PracticeRepository().getAll()).single;
      expect(edited.notes, 'A smaller gesture made the pattern clear.');
      expect(edited.workoutId, result.workoutId);
      expect(edited.workoutDate, result.workoutDate);
      for (final change in [
        {'workoutId': 'another-theme'},
        {'workoutDate': '2028-03-01'},
      ]) {
        await expectLater(
          repository.updateReflection(
            PracticeRecord.fromJson({...edited.toJson(), ...change}),
          ),
          throwsStateError,
        );
      }
      expect((await repository.getAll()).single.toJson(), edited.toJson());
    },
  );

  test('legacy records without daily fields remain importable alongside daily records', () async {
    final legacyJson = _record('legacy').toJson()
      ..remove('workoutId')
      ..remove('workoutDate');
    final daily = _dailyRecord('daily', _dailyPlan().blocks[1]);
    final repository = PracticeRepository();
    await repository.replaceFromJson([legacyJson, daily.toJson()]);
    final restored = await PracticeRepository().getAll();
    final legacy = restored.singleWhere((record) => record.id == 'legacy');
    expect(legacy.workoutId, isNull);
    expect(legacy.workoutDate, isNull);
    expect(legacy.isComparableTo(_record('repeat')), isTrue);
    expect(
      restored.singleWhere((record) => record.id == 'daily').toJson(),
      daily.toJson(),
    );
  });

  test('daily identity rejects partial metadata, impossible dates and invalid levels', () {
    final valid = _dailyRecord('daily', _dailyPlan().blocks[1]).toJson();
    for (final change in <Map<String, Object?>>[
      {'workoutId': null},
      {'workoutDate': null},
      {'workoutId': ' '},
      {'workoutId': 1},
      {'workoutDate': 20260101},
      {'workoutDate': '2026-1-01'},
      {'workoutDate': '2026-02-29'},
      {'workoutDate': '2028-02-30'},
      {'level': -1},
      {'level': 8},
    ]) {
      expect(
        () => PracticeRecord.fromJson({...valid, ...change}),
        throwsFormatException,
      );
    }
  });

  test(
    'history compares recurring variants across dates but not changed tasks',
    () {
      final original = _dailyRecord('original', _dailyPlan(belt: 3).blocks[1]);
      final repeat = _dailyRecord(
        'repeat',
        _dailyPlan(
          date: DateTime.utc(2026, 1, 1 + dailyPracticeThemes.length),
          belt: 3,
          minutes: 45,
        ).blocks[1],
      );
      expect(repeat.workoutDate, isNot(original.workoutDate));
      expect(original.isComparableTo(repeat), isTrue);
      for (final plan in [
        _dailyPlan(date: DateTime.utc(2026, 1, 2), belt: 3),
        _dailyPlan(belt: 4),
        _dailyPlan(belt: 3, support: PracticeSupport.seated),
        _dailyPlan(belt: 3, support: PracticeSupport.supported),
        _dailyPlan(belt: 3, gentle: true),
      ]) {
        expect(
          original.isComparableTo(_dailyRecord('changed', plan.blocks[1])),
          isFalse,
        );
      }
      expect(
        original.isComparableTo(
          _dailyRecord('application', _dailyPlan(belt: 3).blocks[2]),
        ),
        isFalse,
      );
      final conditioned = _dailyPlan(belt: 3, conditioning: true);
      expect(
        original.isComparableTo(
          _dailyRecord('conditioning-enabled', conditioned.blocks[1]),
        ),
        isTrue,
      );
    },
  );

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
