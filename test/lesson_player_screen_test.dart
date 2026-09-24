import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    double textScale = 1,
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
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          ),
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

  for (final size in [const Size(320, 640), const Size(1040, 400)]) {
    testWidgets(
      'written lesson prioritizes scrollable cues without fake media at $size',
      (tester) async {
        await pumpLesson(tester, size: size, textScale: 2);
        expect(find.byType(PageView), findsNothing);
        expect(find.byType(FgMediaDock), findsNothing);
        expect(find.byType(FgImage), findsNothing);
        expect(find.text('lessonWrittenCues'), findsOneWidget);
        final viewport = find.byKey(const ValueKey('lesson-content-scroll'));
        expect(tester.getSize(viewport).height, greaterThan(size.height / 2));
        final step = readyBody.lessons.first.steps.first;
        await tester.ensureVisible(find.text(step.description));
        await tester.pumpAndSettle();
        expect(find.text(step.description).hitTestable(), findsOneWidget);
        final navBefore = tester.getRect(find.byType(FgStepNavigation));
        await tester.ensureVisible(find.text('techniqueDetails'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('techniqueDetails'));
        await tester.pumpAndSettle();
        for (final cue in [step.focus, step.breath, step.energy]) {
          await tester.ensureVisible(find.text(cue));
          await tester.pumpAndSettle();
          expect(find.text(cue).hitTestable(), findsOneWidget);
        }
        expect(tester.getRect(find.byType(FgStepNavigation)), navBefore);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets('next previous and keyboard preserve written step state', (
    tester,
  ) async {
    await pumpLesson(tester, size: const Size(390, 760));
    await tester.tap(find.bySemanticsLabel('nextStepSemantic'));
    await tester.pumpAndSettle();
    expect(find.text(readyBody.lessons.first.steps[1].title), findsOneWidget);
    // Tab puts focus inside the navigation shortcut scope.
    for (var index = 0; index < 8; index++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      if (FocusManager.instance.primaryFocus?.context
              ?.findAncestorWidgetOfExactType<FgStepNavigation>() !=
          null) {
        break;
      }
    }
    expect(
      FocusManager.instance.primaryFocus?.context
          ?.findAncestorWidgetOfExactType<FgStepNavigation>(),
      isNotNull,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowRight);
    await tester.pumpAndSettle();
    expect(find.text(readyBody.lessons.first.steps[2].title), findsOneWidget);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pumpAndSettle();
    expect(find.text(readyBody.lessons.first.steps[1].title), findsOneWidget);
    await tester.tap(find.bySemanticsLabel('previousStepSemantic'));
    await tester.pumpAndSettle();
    expect(
      find.text(readyBody.lessons.first.steps.first.title),
      findsOneWidget,
    );
  });

  testWidgets('step changes reset technique disclosure and reading scroll', (
    tester,
  ) async {
    await pumpLesson(tester, size: const Size(390, 560));
    await tester.ensureVisible(find.text('techniqueDetails'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('techniqueDetails'));
    await tester.pumpAndSettle();
    await tester.drag(
      find.byKey(const ValueKey('lesson-content-scroll')),
      const Offset(0, -220),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.bySemanticsLabel('nextStepSemantic'));
    await tester.pumpAndSettle();
    expect(find.text(readyBody.lessons.first.steps[1].focus), findsNothing);
    expect(find.text('lessonWrittenCues').hitTestable(), findsOneWidget);
  });

  testWidgets(
    'final action completes the lesson through existing progress flow',
    (tester) async {
      var backedOut = false;
      final progress = await pumpLesson(
        tester,
        size: const Size(390, 760),
        onBack: () => backedOut = true,
      );
      for (
        var index = 1;
        index < readyBody.lessons.first.steps.length;
        index++
      ) {
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
}
