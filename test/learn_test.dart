import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/learn/ui/view_model/learn_view_model.dart';

class FakeProgressRepository extends ProgressRepository {
  FakeProgressRepository([Map<String, LessonProgress>? seed])
      : store = {...?seed},
        super(auth: null, firestore: null);

  final Map<String, LessonProgress> store;

  @override
  Future<Map<String, LessonProgress>> getAll() async => {...store};

  @override
  Future<void> upsert(LessonProgress progress) async {
    store[progress.lessonId] = progress;
  }
}

ProviderContainer containerWith(FakeProgressRepository repository) {
  final container = ProviderContainer(
    overrides: [
      progressRepositoryProvider.overrideWithValue(repository),
    ],
  );
  addTearDown(container.dispose);
  container.listen(learnViewModelProvider, (_, __) {});
  return container;
}

void main() {
  final lessons = hipHopFoundations.lessons;

  group('LearnViewModel', () {
    test('fresh user: first lesson is current, everything not started',
        () async {
      final container = containerWith(FakeProgressRepository());

      final state = await container.read(learnViewModelProvider.future);

      expect(state.activeModule, hipHopFoundations);
      expect(state.currentLesson, lessons.first);
      for (final lesson in lessons) {
        expect(state.statusOf(lesson), LessonStatus.notStarted);
      }
    });

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

    test('selectModule switches the active module, ignoring unknown ids',
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
      expect(state.completedCountIn(hipHopFoundations), 0);
      expect(state.currentLessonIn(topRock), topRock.lessons[1]);
    });

    test('collection, continue, and recommended rails derive from progress',
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
      expect(state.collectedLessons.length, 2);
      expect(state.collectedLessons.first.module, topRock);
      expect(state.collectedLessons.first.lesson, topRock.lessons.first);

      // Continue rail: the started modules (active module is untouched).
      expect(state.inProgressModules, [topRock, house]);

      // Recommended: untouched modules, excluding the active one.
      expect(state.recommendedModules.contains(hipHopFoundations), isFalse);
      expect(state.recommendedModules.contains(topRock), isFalse);
      expect(state.recommendedModules.length, 3);
    });

    test('startLesson marks in-progress but never downgrades completed',
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
    });
  });

  group('ProgressRepository (unconfigured Firebase)', () {
    test('reads empty and writes no-op instead of throwing', () async {
      const repository = ProgressRepository(auth: null, firestore: null);

      expect(repository.isFirebaseConfigured, isFalse);
      expect(await repository.getAll(), isEmpty);
      await repository.upsert(
        const LessonProgress(lessonId: 'x', status: LessonStatus.completed),
      );
    });
  });
}
