import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/model/lesson.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/stats/model/stats_rules.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';

class FakeProgressRepository extends ProgressRepository {
  FakeProgressRepository([Map<String, LessonProgress>? seed])
    : store = {...?seed},
      super();

  final Map<String, LessonProgress> store;

  @override
  Future<Map<String, LessonProgress>> getAll() async => {...store};

  @override
  Future<void> upsert(LessonProgress progress) async {
    store[progress.lessonId] = progress;
  }

  @override
  Future<({LessonProgress progress, bool created})> completeOnce(
    LessonProgress completion,
  ) async {
    final existing = store[completion.lessonId];
    if (existing?.status == LessonStatus.completed) {
      return (progress: existing!, created: false);
    }
    store[completion.lessonId] = completion;
    return (progress: completion, created: true);
  }
}

/// In-memory profile store so the stats coordinator (triggered by lesson
/// progress events) never touches SharedPreferences in tests.
class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository() : super();

  Profile? saved;

  @override
  Future<Profile?> get() async => saved;

  @override
  Future<void> update(Profile profile) async {
    saved = profile;
  }
}

ProviderContainer containerWith(
  FakeProgressRepository repository, {
  FakeProfileRepository? profileRepository,
}) {
  SharedPreferences.setMockInitialValues({});
  final container = ProviderContainer(
    overrides: [
      progressRepositoryProvider.overrideWithValue(repository),
      profileRepositoryProvider.overrideWithValue(
        profileRepository ?? FakeProfileRepository(),
      ),
      // The stats coordinator also reads workout sessions; use an empty local repository.
      sessionRepositoryProvider.overrideWithValue(
        const SessionRepository(),
      ),
    ],
  );
  addTearDown(container.dispose);
  container.listen(learnViewModelProvider, (_, _) {});
  return container;
}

void main() {
  final lessons = readyBody.lessons;

  group('catalog learning tree', () {
    test('starts with six common modules containing 18 authored units', () {
      expect(commonFoundationModules, hasLength(6));
      expect(allModules.take(6), orderedEquals(commonFoundationModules));
      expect(
        commonFoundationModules.expand((module) => module.lessons),
        hasLength(18),
      );

      for (final module in commonFoundationModules) {
        expect(module.pathway, LearningPathway.commonFoundation);
        expect(module.lessons, hasLength(3));
        expect(module.lessons.last.type, LessonType.boss);
        for (final lesson in module.lessons) {
          expect(lesson.duration, '10 min');
          expect(lesson.steps, hasLength(4));
        }
      }
    });

    test('catalog ids and prerequisite graph are valid and ordered', () {
      final moduleIds = <String>{};
      final lessonIds = <String>{};
      final lessonIndex = <String, int>{};
      var index = 0;

      for (final module in allModules) {
        expect(
          moduleIds.add(module.id),
          isTrue,
          reason: 'duplicate module id ${module.id}',
        );
        for (final lesson in module.lessons) {
          expect(
            lessonIds.add(lesson.id),
            isTrue,
            reason: 'duplicate lesson id ${lesson.id}',
          );
          lessonIndex[lesson.id] = index++;
        }
      }

      for (final module in allModules) {
        final moduleStart = lessonIndex[module.lessons.first.id]!;
        for (final prerequisiteId in module.prerequisiteLessonIds) {
          expect(lessonIndex, contains(prerequisiteId));
          expect(
            lessonIndex[prerequisiteId],
            lessThan(moduleStart),
            reason: '${module.id} must depend only on earlier lessons',
          );
          expect(
            module.lessons.any((lesson) => lesson.id == prerequisiteId),
            isFalse,
            reason: '${module.id} must not depend on itself',
          );
        }
      }
    });

    test('Unit 6 unlocks sampling but not substantive branches', () async {
      final unit6 = timeAndWeight.lessons.last;
      final container = containerWith(
        FakeProgressRepository({
          unit6.id: LessonProgress(
            lessonId: unit6.id,
            status: LessonStatus.completed,
          ),
        }),
      );
      final state = await container.read(learnViewModelProvider.future);

      expect(state.isModuleUnlocked(spaceAndCoordination), isTrue);
      expect(state.isModuleUnlocked(hipHopFoundations), isTrue);
      expect(state.unmetPrerequisiteLessonIds(topRock), isNotEmpty);
      expect(state.isModuleUnlocked(topRock), isFalse);
      expect(state.isModuleUnlocked(urbanFlow), isFalse);
    });

    test('Unit 12 unlocks represented solo style branches', () async {
      final unit12 = qualityAndPhrase.lessons.last;
      final container = containerWith(
        FakeProgressRepository({
          unit12.id: LessonProgress(
            lessonId: unit12.id,
            status: LessonStatus.completed,
          ),
        }),
      );
      final state = await container.read(learnViewModelProvider.future);

      for (final module in [
        isolationsMaster,
        topRock,
        boogaloo,
        house,
        breakingBasics,
        urbanFlow,
        contemporaryFusion,
      ]) {
        expect(state.isModuleUnlocked(module), isTrue, reason: module.id);
      }
    });
  });

  group('LearnViewModel', () {
    test(
      'fresh user: first lesson is current, everything not started',
      () async {
        final container = containerWith(FakeProgressRepository());

        final state = await container.read(learnViewModelProvider.future);

        expect(state.activeModule, readyBody);
        expect(state.currentLesson, lessons.first);
        expect(state.recommendedModules, isEmpty);
        for (final lesson in lessons) {
          expect(state.statusOf(lesson), LessonStatus.notStarted);
        }
      },
    );

    test('progress determines the current lesson on the path', () async {
      final container = containerWith(
        FakeProgressRepository({
          lessons[0].id: LessonProgress(
            lessonId: lessons[0].id,
            status: LessonStatus.completed,
            progress: 1.0,
          ),
        }),
      );

      final state = await container.read(learnViewModelProvider.future);

      expect(state.statusOf(lessons[0]), LessonStatus.completed);
      expect(state.currentLesson, lessons[1]);
    });

    test('completeLesson persists and unlocks the next lesson', () async {
      final repository = FakeProgressRepository();
      final container = containerWith(repository);
      await container.read(learnViewModelProvider.future);

      await container
          .read(learnViewModelProvider.notifier)
          .completeLesson(lessons.first.id);

      expect(
        repository.store[lessons.first.id]?.status,
        LessonStatus.completed,
      );
      final state = container.read(learnViewModelProvider).value!;
      expect(state.statusOf(lessons.first), LessonStatus.completed);
      expect(state.currentLesson, lessons[1]);
    });

    test('completedCount and moduleProgress derive from progress', () async {
      final container = containerWith(
        FakeProgressRepository({
          lessons[0].id: LessonProgress(
            lessonId: lessons[0].id,
            status: LessonStatus.completed,
            progress: 1.0,
          ),
          lessons[1].id: LessonProgress(
            lessonId: lessons[1].id,
            status: LessonStatus.completed,
            progress: 1.0,
          ),
          lessons[2].id: LessonProgress(
            lessonId: lessons[2].id,
            status: LessonStatus.inProgress,
          ),
        }),
      );

      final state = await container.read(learnViewModelProvider.future);

      expect(state.completedCount, 2);
      expect(state.moduleProgress, closeTo(2 / lessons.length, 0.0001));
      expect(state.currentLesson, lessons[2]);
    });

    test(
      'selectModule switches the active module, ignoring unknown ids',
      () async {
        final container = containerWith(FakeProgressRepository());
        await container.read(learnViewModelProvider.future);
        final notifier = container.read(learnViewModelProvider.notifier);

        notifier.selectModule(topRock.id);
        expect(
          container.read(learnViewModelProvider).value?.activeModule,
          topRock,
        );

        notifier.selectModule('does-not-exist');
        expect(
          container.read(learnViewModelProvider).value?.activeModule,
          topRock,
        );
      },
    );

    test('Learn owns locked lesson entry policy', () async {
      final container = containerWith(FakeProgressRepository());
      var state = await container.read(learnViewModelProvider.future);
      expect(state.canOpenLesson(lessons.first.id), isTrue);
      expect(state.canOpenLesson(lessons[1].id), isFalse);

      await container
          .read(learnViewModelProvider.notifier)
          .completeLesson(lessons.first.id);
      state = container.read(learnViewModelProvider).value!;
      expect(state.canOpenLesson(lessons[1].id), isTrue);
    });

    test('module progress is isolated per module', () async {
      final container = containerWith(
        FakeProgressRepository({
          topRock.lessons.first.id: LessonProgress(
            lessonId: topRock.lessons.first.id,
            status: LessonStatus.completed,
            progress: 1.0,
          ),
        }),
      );

      final state = await container.read(learnViewModelProvider.future);

      expect(state.completedCountIn(topRock), 1);
      expect(state.completedCountIn(readyBody), 0);
      expect(state.currentLessonIn(topRock), topRock.lessons[1]);
      expect(state.isModuleUnlocked(topRock), isTrue);
      expect(state.canOpenLesson(topRock.lessons[1].id), isTrue);
    });

    test(
      'collection, continue, and recommended rails derive from progress',
      () async {
        final container = containerWith(
          FakeProgressRepository({
            topRock.lessons.first.id: LessonProgress(
              lessonId: topRock.lessons.first.id,
              status: LessonStatus.completed,
              progress: 1.0,
            ),
            house.lessons.first.id: LessonProgress(
              lessonId: house.lessons.first.id,
              status: LessonStatus.inProgress,
            ),
          }),
        );

        final state = await container.read(learnViewModelProvider.future);

        // Collection: exactly the two touched lessons, paired with modules.
        expect(state.library.entries.length, 2);
        expect(state.library.entries.first.module, topRock);
        expect(state.library.entries.first.lesson, topRock.lessons.first);

        // Continue rail: the started modules (active module is untouched).
        expect(state.inProgressModules, [topRock, house]);

        // Recommended: untouched modules, excluding the active one.
        expect(state.recommendedModules.contains(readyBody), isFalse);
        expect(state.recommendedModules.contains(topRock), isFalse);
        expect(state.recommendedModules.every(state.isModuleUnlocked), isTrue);
      },
    );

    test(
      'library projection applies query and catalog-backed filters',
      () async {
        final lesson = topRock.lessons.first;
        final container = containerWith(
          FakeProgressRepository({
            lesson.id: LessonProgress(
              lessonId: lesson.id,
              status: LessonStatus.completed,
            ),
          }),
        );
        final library = (await container.read(learnViewModelProvider.future))
            .library;

        expect(library.matching(query: topRock.title), hasLength(1));
        expect(library.matching(type: lesson.type.label), hasLength(1));
        expect(library.matching(type: 'Concept'), isEmpty);
        expect(library.types, contains(lesson.type.label));
      },
    );

    test('completing a lesson records XP and streak on the profile', () async {
      final profileRepository = FakeProfileRepository();
      final container = containerWith(
        FakeProgressRepository(),
        profileRepository: profileRepository,
      );
      await container.read(learnViewModelProvider.future);

      // First lesson of the first module is theory → 20 XP.
      await container
          .read(learnViewModelProvider.notifier)
          .completeLesson(lessons.first.id);

      final saved = profileRepository.saved;
      expect(saved, isNotNull);
      expect(saved!.xp, 20);
      expect(saved.streakCount, 1);
      expect(saved.lastActivityDate, dateKey(DateTime.now()));
    });

    test(
      'locked lesson intents do not write progress or award activity',
      () async {
        final repository = FakeProgressRepository();
        final profileRepository = FakeProfileRepository();
        final container = containerWith(
          repository,
          profileRepository: profileRepository,
        );
        await container.read(learnViewModelProvider.future);
        final notifier = container.read(learnViewModelProvider.notifier);
        final lockedLesson = topRock.lessons.first;

        await notifier.startLesson(lockedLesson.id);
        await notifier.completeLesson(lockedLesson.id);

        expect(repository.store, isEmpty);
        expect(profileRepository.saved, isNull);
      },
    );

    test(
      'startLesson marks in-progress but never downgrades completed',
      () async {
        final repository = FakeProgressRepository();
        final container = containerWith(repository);
        await container.read(learnViewModelProvider.future);
        final notifier = container.read(learnViewModelProvider.notifier);

        await notifier.startLesson(lessons.first.id);
        expect(
          repository.store[lessons.first.id]?.status,
          LessonStatus.inProgress,
        );

        await notifier.completeLesson(lessons.first.id);
        await notifier.startLesson(lessons.first.id);
        expect(
          repository.store[lessons.first.id]?.status,
          LessonStatus.completed,
        );
      },
    );
  });

  group('lesson step content quality gate', () {
    test('every lesson resolves to complete, non-empty step content', () {
      for (final module in allModules) {
        for (final lesson in module.lessons) {
          final steps = stepsFor(lesson);
          expect(
            steps,
            isNotEmpty,
            reason: '${lesson.id} has no effective steps',
          );
          for (final step in steps) {
            expect(
              step.title.trim(),
              isNotEmpty,
              reason: '${lesson.id} step title empty',
            );
            expect(
              step.description.trim(),
              isNotEmpty,
              reason: '${lesson.id}/${step.title} missing description',
            );
            expect(
              step.focus.trim(),
              isNotEmpty,
              reason: '${lesson.id}/${step.title} missing focus tip',
            );
            expect(
              step.breath.trim(),
              isNotEmpty,
              reason: '${lesson.id}/${step.title} missing breath tip',
            );
            expect(
              step.energy.trim(),
              isNotEmpty,
              reason: '${lesson.id}/${step.title} missing energy tip',
            );
          }
        }
      }
    });

    test('the common foundation is fully hand-authored', () {
      for (final module in commonFoundationModules) {
        for (final lesson in module.lessons) {
          expect(
            lesson.steps,
            isNotEmpty,
            reason: '${lesson.id} should have authored steps',
          );
          expect(lesson.steps, hasLength(4));
        }
      }
      expect(readyBody.lessons.first.steps.first.title, 'CONCEPT & CHOICE');
    });
  });

  group('ProgressRepository (local storage)', () {
    test('reads empty and persists progress', () async {
      SharedPreferences.setMockInitialValues({});
      const repository = ProgressRepository();

      expect(await repository.getAll(), isEmpty);
      await repository.upsert(
        const LessonProgress(lessonId: 'x', status: LessonStatus.completed),
      );

      expect((await repository.getAll())['x']?.status, LessonStatus.completed);
    });
  });
}
