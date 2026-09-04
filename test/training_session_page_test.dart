import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/workout/model/workout_session.dart';
import 'package:forge_dance/features/workout/presentation/pages/training_session_page.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';
import 'package:forge_dance/features/workout/repository/workout_catalog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeSessionRepository extends SessionRepository {
  _FakeSessionRepository([List<WorkoutSession> seed = const []])
    : store = {for (final session in seed) session.docKey: session},
      super();

  final Map<String, WorkoutSession> store;

  @override
  Future<List<WorkoutSession>> getAll() async => store.values.toList();

  @override
  Future<void> complete(WorkoutSession session) async {
    store[session.docKey] = session;
  }

  @override
  Future<({WorkoutSession session, bool created})> completeOnce(
    WorkoutSession completion,
  ) async {
    final existing = store[completion.docKey];
    if (existing != null) return (session: existing, created: false);
    store[completion.docKey] = completion;
    return (session: completion, created: true);
  }
}

class _FakeProfileRepository extends ProfileRepository {
  _FakeProfileRepository() : super();

  Profile? saved;

  @override
  Future<Profile?> get() async => saved;

  @override
  Future<void> update(Profile profile) async {
    saved = profile;
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<_FakeSessionRepository> pumpTraining(
    WidgetTester tester, {
    required Size size,
    VoidCallback? onClose,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final repository = _FakeSessionRepository();
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          sessionRepositoryProvider.overrideWithValue(repository),
          profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
          progressRepositoryProvider.overrideWithValue(
            const ProgressRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppThemes.dark,
          home: TrainingSessionPage(onClose: onClose),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return repository;
  }

  group('adaptive workout training flow', () {
    testWidgets('overview presents workout purpose and starts training', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());

      expect(find.text(wod.title), findsWidgets);
      expect(find.text(wod.description), findsOneWidget);
      expect(find.text('exercisesCount'), findsOneWidget);
      expect(find.text('minutesCount'), findsWidgets);
      expect(find.text('xpReward'), findsOneWidget);
      expect(find.text('startTraining'), findsOneWidget);

      await tester.tap(find.text('startTraining'));
      await tester.pumpAndSettle();

      expect(find.text(wod.exercises.first.name), findsWidgets);
      expect(find.text('${wod.exercises.first.seconds}s'), findsOneWidget);
    });

    testWidgets('locked forward progression shows feedback and explicit skip', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());
      await tester.tap(find.text('startTraining'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('nextStep'));
      await tester.pumpAndSettle();

      expect(find.text('completeTimerToContinue'), findsOneWidget);
      expect(find.text(wod.exercises.first.name), findsWidgets);
      expect(find.text('SKIP'), findsOneWidget);

      await tester.tap(find.text('SKIP'));
      await tester.pumpAndSettle();

      expect(find.text(wod.exercises[1].name), findsWidgets);
    });

    testWidgets(
      'media swipe is gated forward but still supports backward navigation',
      (tester) async {
        await pumpTraining(tester, size: const Size(1000, 700));
        final wod = wodFor(DateTime.now());
        await tester.tap(find.text('startTraining'));
        await tester.pumpAndSettle();

        await tester.drag(
          find.byKey(const ValueKey('workout-content-scroll')),
          const Offset(-320, 0),
        );
        await tester.pumpAndSettle();
        expect(find.text(wod.exercises.first.name), findsWidgets);

        await tester.fling(
          find.byKey(const ValueKey('workout-media-swipe-zone')),
          const Offset(-320, 0),
          1000,
        );
        await tester.pumpAndSettle();
        expect(find.text('completeTimerToContinue'), findsOneWidget);
        expect(find.text(wod.exercises.first.name), findsWidgets);

        await tester.tap(find.text('SKIP'));
        await tester.pumpAndSettle();
        expect(find.text(wod.exercises[1].name), findsWidgets);

        await tester.fling(
          find.byKey(const ValueKey('workout-media-swipe-zone')),
          const Offset(320, 0),
          1000,
        );
        await tester.pumpAndSettle();
        expect(find.text(wod.exercises.first.name), findsWidgets);
      },
    );

    testWidgets('timer completion enables progression', (tester) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());
      final first = wod.exercises.first;
      await tester.tap(find.text('startTraining'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('${first.seconds}s'));
      for (var second = 0; second <= first.seconds; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.pumpAndSettle();

      await tester.tap(find.text('nextStep'));
      await tester.pumpAndSettle();

      expect(find.text(wod.exercises[1].name), findsWidgets);
    });

    testWidgets('narrow scrolling hides media and restore brings it back', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      await tester.tap(find.text('startTraining'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('workout-content-scroll')),
        const Offset(0, -220),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsNothing);
      expect(find.text('restoreLessonMedia'), findsOneWidget);

      await tester.tap(find.text('restoreLessonMedia'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsOneWidget);
      expect(find.text('restoreLessonMedia'), findsNothing);
    });

    testWidgets('completion records session reward and finish closes', (
      tester,
    ) async {
      var closed = false;
      final repository = await pumpTraining(
        tester,
        size: const Size(390, 760),
        onClose: () => closed = true,
      );
      final wod = wodFor(DateTime.now());
      await tester.tap(find.text('startTraining'));
      await tester.pumpAndSettle();

      for (var index = 0; index < wod.exercises.length; index++) {
        await tester.tap(find.text('skip'));
        await tester.pumpAndSettle();
      }

      expect(find.text('sessionComplete'), findsWidgets);
      expect(find.text('youEarnedXp'), findsOneWidget);
      expect(repository.store, hasLength(1));

      await tester.tap(find.text('finish'));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });
  });
}
