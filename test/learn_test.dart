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

      expect(state.module, hipHopFoundations);
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
