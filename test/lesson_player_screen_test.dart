import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/learn/model/lesson_progress.dart';
import 'package:forge_dance/features/learn/repository/lesson_catalog.dart';
import 'package:forge_dance/features/learn/repository/progress_repository.dart';
import 'package:forge_dance/features/learn/ui/lesson_player_screen.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/workout/repository/session_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _FakeProgressRepository extends ProgressRepository {
  _FakeProgressRepository([Map<String, LessonProgress>? seed])
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

  Future<_FakeProgressRepository> pumpLesson(
    WidgetTester tester, {
    required Size size,
    VoidCallback? onBack,
  }) async {
    SharedPreferences.setMockInitialValues({});
    final progress = _FakeProgressRepository();
    await tester.binding.setSurfaceSize(size);
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          progressRepositoryProvider.overrideWithValue(progress),
          profileRepositoryProvider.overrideWithValue(_FakeProfileRepository()),
          sessionRepositoryProvider.overrideWithValue(
            const SessionRepository(),
          ),
        ],
        child: MaterialApp(
          theme: AppThemes.dark,
          home: LessonPlayerScreen(
            lessonId: readyBody.lessons.first.id,
            onBack: onBack,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    return progress;
  }

  group('adaptive lesson player', () {
    testWidgets(
      'narrow lessons show summary first and reveal technique details',
      (tester) async {
        await pumpLesson(tester, size: const Size(390, 760));
        final firstStep = readyBody.lessons.first.steps.first;

        expect(find.text('lessonStepOf'), findsNothing);
        expect(find.bySemanticsLabel('lessonStepOf'), findsOneWidget);
        expect(find.text(firstStep.title), findsWidgets);
        expect(find.text(firstStep.description), findsOneWidget);
        expect(find.text(firstStep.focus), findsNothing);
        expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
        expect(find.byIcon(Icons.arrow_forward_rounded), findsOneWidget);
        expect(find.text('nextStep'), findsNothing);
        expect(find.text('previousStep'), findsNothing);
        expect(find.bySemanticsLabel('goToLessonStep'), findsNothing);
        final previousButton = find.bySemanticsLabel('previousStepSemantic');
        final nextButton = find.bySemanticsLabel('nextStepSemantic');
        expect(tester.getSize(previousButton), tester.getSize(nextButton));
        expect(
          tester.getCenter(previousButton).dx,
          lessThan(tester.getCenter(find.byType(FgProgressBar)).dx),
        );
        expect(
          tester.getCenter(find.byType(FgProgressBar)).dx,
          lessThan(tester.getCenter(nextButton).dx),
        );
        final progressBar = tester.widget<FgProgressBar>(
          find.byType(FgProgressBar),
        );
        expect(progressBar.segments, readyBody.lessons.first.steps.length);
        expect(progressBar.value, 0.25);

        await tester.ensureVisible(find.text('techniqueDetails'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('techniqueDetails'));
        await tester.pumpAndSettle();

        expect(find.text(firstStep.focus), findsOneWidget);
        expect(find.text(firstStep.breath), findsOneWidget);
        expect(find.text(firstStep.energy), findsOneWidget);
      },
    );

    testWidgets('narrow content scroll docks media and expand brings it back', (
      tester,
    ) async {
      await pumpLesson(tester, size: const Size(390, 760));

      expect(find.byKey(const ValueKey('lesson-media-shell')), findsOneWidget);

      await tester.drag(
        find.byKey(const ValueKey('lesson-content-scroll')),
        const Offset(0, -220),
      );
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('lesson-media-shell')), findsNothing);
      expect(find.byKey(const ValueKey('lesson-media-dock')), findsOneWidget);
      expect(find.text('lessonStepOf'), findsWidgets);

      await tester.tap(find.byIcon(Icons.expand_less_rounded));
      await tester.pumpAndSettle();

      expect(find.byKey(const ValueKey('lesson-media-shell')), findsOneWidget);
      expect(find.byKey(const ValueKey('lesson-media-dock')), findsNothing);
    });

    testWidgets(
      'wide lessons place navigation in the content panel and swipe only on media',
      (tester) async {
        await pumpLesson(tester, size: const Size(1000, 430));
        final firstStep = readyBody.lessons.first.steps.first;
        final secondStep = readyBody.lessons.first.steps[1];

        await tester.drag(
          find.byKey(const ValueKey('lesson-content-scroll')),
          const Offset(-320, 0),
        );
        await tester.pumpAndSettle();
        expect(find.text('lessonStepOf'), findsNothing);
        expect(find.bySemanticsLabel('lessonStepOf'), findsOneWidget);
        expect(find.text(firstStep.title), findsWidgets);

        await tester.drag(
          find.byKey(const ValueKey('lesson-media-page-view')),
          const Offset(-320, 0),
        );
        await tester.pumpAndSettle();

        expect(find.text('lessonStepOf'), findsNothing);
        expect(find.bySemanticsLabel('lessonStepOf'), findsOneWidget);
        expect(find.text(secondStep.title), findsWidgets);
      },
    );

    testWidgets(
      'step changes reset expanded media and collapse technique details',
      (tester) async {
        await pumpLesson(tester, size: const Size(390, 560));
        final secondStep = readyBody.lessons.first.steps[1];

        await tester.tap(find.text('techniqueDetails'));
        await tester.pumpAndSettle();
        await tester.drag(
          find.byKey(const ValueKey('lesson-content-scroll')),
          const Offset(0, -220),
        );
        await tester.pumpAndSettle();
        expect(find.byKey(const ValueKey('lesson-media-dock')), findsOneWidget);

        await tester.tap(find.bySemanticsLabel('nextStepSemantic'));
        await tester.pumpAndSettle();

        expect(find.text('lessonStepOf'), findsNothing);
        expect(find.bySemanticsLabel('lessonStepOf'), findsOneWidget);
        expect(find.byKey(const ValueKey('lesson-media-dock')), findsNothing);
        expect(find.text(secondStep.focus), findsNothing);
      },
    );

    testWidgets(
      'final action completes the lesson through existing progress flow',
      (tester) async {
        var backedOut = false;
        final progress = await pumpLesson(
          tester,
          size: const Size(390, 760),
          onBack: () => backedOut = true,
        );

        for (var index = 0; index < 3; index++) {
          await tester.tap(find.bySemanticsLabel('nextStepSemantic'));
          await tester.pumpAndSettle();
        }
        await tester.tap(find.bySemanticsLabel('completeLesson'));
        await tester.pumpAndSettle();

        expect(
          progress.store[readyBody.lessons.first.id]?.status,
          LessonStatus.completed,
        );
        expect(backedOut, isTrue);
      },
    );
  });
}
