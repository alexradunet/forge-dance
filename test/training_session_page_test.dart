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
    double textScale = 1,
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
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
          home: TrainingSessionPage(onClose: onClose),
        ),
      ),
    );
    // The overview photo has an animated loading placeholder.
    for (var frame = 0; frame < 8; frame++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    return repository;
  }

  testWidgets('small screen supports doubled player text', (tester) async {
    await pumpTraining(tester, size: const Size(320, 640), textScale: 2);
    await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.byType(FgStepNavigation), findsOneWidget);
  });

  group('adaptive workout training flow', () {
    testWidgets('overview presents workout purpose and starts training', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());

      expect(find.text(wod.title), findsWidgets);
      expect(find.text(wod.description), findsOneWidget);
      expect(find.text('EXERCISESCOUNT'), findsOneWidget);
      expect(find.text('MINUTESCOUNT'), findsWidgets);
      expect(find.text('XPREWARD'), findsOneWidget);
      expect(find.byType(FgStepNavigation), findsNothing);
      expect(find.byType(FgTimerControl), findsNothing);
      expect(find.bySemanticsLabel('startWorkoutSemantic'), findsOneWidget);
      expect(find.text(wod.exercises.first.name), findsOneWidget);

      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();

      expect(find.text(wod.exercises.first.name), findsWidgets);
      expect(find.text('${wod.exercises.first.seconds}s'), findsOneWidget);
    });

    testWidgets('start is explicit and skipping resets the next countdown', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());
      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();
      final firstSeconds = wod.exercises.first.seconds;
      await tester.pump(const Duration(seconds: 5));
      expect(find.text('${firstSeconds}s'), findsOneWidget);
      await tester.tap(find.text('${firstSeconds}s'));
      for (var tick = 0; tick < 3; tick++) {
        await tester.pump(const Duration(seconds: 1));
      }
      expect(find.text('${firstSeconds - 3}s'), findsOneWidget);
      await tester.ensureVisible(find.text('skip'));
      await tester.pump();
      await tester.tap(find.text('skip'));
      await tester.pumpAndSettle();
      expect(find.text('${wod.exercises[1].seconds}s'), findsOneWidget);
      expect(find.text(wod.exercises[1].name), findsOneWidget);
    });

    testWidgets(
      'old skip feedback cannot change another step or disposed player',
      (tester) async {
        await pumpTraining(tester, size: const Size(390, 760));
        final wod = wodFor(DateTime.now());
        await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
        await tester.pumpAndSettle();
        await tester.tap(find.bySemanticsLabel('nextLockedSemantic'));
        await tester.pumpAndSettle();
        final oldAction = tester
            .widget<SnackBarAction>(find.byType(SnackBarAction))
            .onPressed;
        await tester.ensureVisible(find.text('skip'));
        await tester.pump();
        await tester.tap(find.text('skip'));
        await tester.pumpAndSettle();
        oldAction();
        await tester.pumpAndSettle();
        expect(find.text(wod.exercises[1].name), findsOneWidget);
        await tester.pumpWidget(const SizedBox.shrink());
        oldAction();
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets('locked forward progression shows feedback and explicit skip', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 760));
      final wod = wodFor(DateTime.now());
      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('nextLockedSemantic'));
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
        await pumpTraining(tester, size: const Size(1000, 430));
        final wod = wodFor(DateTime.now());
        await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
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
      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('${first.seconds}s'));
      for (var second = 0; second <= first.seconds; second++) {
        await tester.pump(const Duration(seconds: 1));
      }
      await tester.pumpAndSettle();

      await tester.tap(find.bySemanticsLabel('nextStepSemantic'));
      await tester.pumpAndSettle();

      expect(find.text(wod.exercises[1].name), findsWidgets);
    });

    testWidgets('narrow scrolling docks media and expand brings it back', (
      tester,
    ) async {
      await pumpTraining(tester, size: const Size(390, 560));
      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('workout-content-scroll')),
        const Offset(0, -220),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsNothing);
      expect(find.byKey(const ValueKey('workout-media-dock')), findsOneWidget);
      final timerSeconds = wodFor(DateTime.now()).exercises.first.seconds;
      expect(find.text('${timerSeconds}s'), findsOneWidget);

      await tester.tap(find.text('${timerSeconds}s'));
      await tester.pump(const Duration(seconds: 1));
      expect(find.text('${timerSeconds - 1}s'), findsOneWidget);

      await tester.tap(find.byIcon(Icons.expand_less_rounded));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('workout-media-shell')), findsOneWidget);
      expect(find.byKey(const ValueKey('workout-media-dock')), findsNothing);
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
      await tester.tap(find.bySemanticsLabel('startWorkoutSemantic'));
      await tester.pumpAndSettle();

      for (var index = 0; index < wod.exercises.length; index++) {
        await tester.tap(find.text('skip'));
        await tester.pumpAndSettle();
      }

      expect(find.text('sessionComplete'), findsWidgets);
      expect(find.text('youEarnedXp'), findsOneWidget);
      expect(repository.store, hasLength(1));

      await tester.tap(find.bySemanticsLabel('finish'));
      await tester.pumpAndSettle();

      expect(closed, isTrue);
    });
  });
}
