part of 'feature_surface_contract_test.dart';

// Private destinations (programme detail and reflection) are opened below from
// their public parents; they belong to this central surface inventory too.
final _learningImmersiveScreens = <String, Widget Function()>{
  'Module path': () => ModuleViewScreen(onLessonNavigate: (_) {}),
  'Lesson player': () =>
      LessonPlayerScreen(lessonId: readyBody.lessons.first.id),
  'Lesson history': () => const CollectionPage(),
  'Stats': () => const StatsPage(),
};

Map<String, Object> _lessonPreferences(Iterable<LessonProgress> progress) => {
  Constants.lessonProgressKey: jsonEncode({
    for (final item in progress) item.lessonId: item.toJson(),
  }),
};

PracticeRecord _historyRecord(String id, {int seconds = 60}) => PracticeRecord(
  id: id,
  blockId: 'pulse-walk',
  lessonId: 'ready-body-1',
  title: 'Pulse walk',
  category: ForgeCategory.rhythm,
  level: 1,
  performedAt: DateTime.utc(2026, 9, id == 'earlier' ? 6 : 7),
  durationSeconds: seconds,
  bpm: 80,
  attempts: 2,
  difficulty: 4,
  notes: 'Steady pulse, comfortable range.',
);

Future<void> _openProgramme(WidgetTester tester) async {
  final preview = find.byKey(
    ValueKey('programme-preview-${forgeProgrammes.first.id}'),
  );
  await _show(tester, preview);
  await tester.tap(preview);
  await tester.pumpAndSettle();
}

// Storage providers are created in the real async zone by _pumpFeature.
// Keep writes in that zone too; otherwise their static queues can strand the
// next test's fixture while a fake-zone callback waits for a real-zone future.
Future<void> _tapStorage(WidgetTester tester, Finder target) async {
  await tester.runAsync(() async {
    await tester.tap(target);
    await Future<void>.delayed(const Duration(milliseconds: 20));
  });
}

void _expectTopRouteDark(WidgetTester tester) {
  final surface = tester.widget<FgImmersiveScaffold>(
    find.byType(FgImmersiveScaffold).last,
  );
  _expectDarkScreen(tester, surface);
}

class _RetryMethodRepository extends MethodRepository {
  final submissions = <AssessmentAttempt>[];
  MethodProgress progress = MethodProgress();
  Future<MethodProgress>? nextRead;
  bool fail = true;
  Completer<void>? saving;
  @override
  Future<MethodProgress> get() => nextRead ?? Future.value(progress);
  @override
  Future<MethodProgress> recordAssessment(AssessmentAttempt attempt) async {
    submissions.add(attempt);
    if (saving != null) await saving!.future;
    if (fail) throw StateError('disk full');
    progress = MethodProgress(attempts: [...progress.attempts, attempt]);
    return progress;
  }
}

class _SurfaceProgressRepository extends ProgressRepository {
  Future<Map<String, LessonProgress>>? nextRead;
  bool failCompletion = false;
  final submissions = <LessonProgress>[];
  @override
  Future<Map<String, LessonProgress>> getAll() => nextRead ?? super.getAll();
  @override
  Future<({LessonProgress progress, bool created})> completeOnce(
    LessonProgress completion,
  ) {
    submissions.add(completion);
    if (failCompletion) throw StateError('disk full');
    return super.completeOnce(completion);
  }
}

class _SurfacePracticeRepository extends PracticeRepository {
  Future<List<PracticeRecord>>? nextRead;
  bool failUpdate = false;
  @override
  Future<List<PracticeRecord>> getAll() => nextRead ?? super.getAll();
  @override
  Future<void> updateReflection(PracticeRecord record) async {
    if (failUpdate) throw StateError('disk full');
    await super.updateReflection(record);
  }
}

void _learningSurfaceContracts() {
  for (final width in [320.0, 1040.0]) {
    for (final entry in <String, Widget Function()>{
      ..._learningImmersiveScreens,
      'Method overview': () => const MethodPage(),
      'Method category': () =>
          const MethodPage(initialCategory: ForgeCategory.rhythm),
      'Assessment': () => const MethodPage(initialAssessmentId: 'rhythm-1-v1'),
      'Practice history': () => const PracticeLogPage(),
    }.entries) {
      testWidgets('${entry.key} reading surface at $width / 2x light host', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final page = entry.value();
        await _pumpFeature(tester, page, textScale: 2);
        _expectDarkScreen(tester, page);
        if (page is MethodPage) {
          final disclosure = find.byType(FgDetails).first;
          await _show(tester, disclosure);
          await tester.tap(disclosure);
          await tester.pumpAndSettle();
          _expectDarkScreen(tester, page);
        }
      });
    }

    testWidgets('Programme detail and locked assessment at $width / 2x', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpFeature(tester, const ProgrammesPage(), textScale: 2);
      await _openProgramme(tester);
      _expectTopRouteDark(tester);
      final start = find.widgetWithText(
        FgButton,
        LocaleKeys.programmesStart.tr(),
      );
      await _show(tester, start);
      await _tapStorage(tester, start);
      await tester.pumpAndSettle();
      final about = find.byKey(
        ValueKey('programme-about-${forgeProgrammes.first.id}'),
      );
      await _show(tester, about);
      await tester.tap(about);
      await tester.pumpAndSettle();
      expect(find.text(forgeProgrammes.first.description), findsOneWidget);
      expect(
        find.text(LocaleKeys.programmesCompletionNotMastery.tr()),
        findsOneWidget,
      );
      _expectTopRouteDark(tester);
      expect(find.text(LocaleKeys.programmesOpenAssessment.tr()), findsNothing);
      await _openDetails(
        tester,
        find.byKey(
          ValueKey('programme-assessment-${forgeProgrammes.first.id}'),
        ),
      );
      final assessment = find.widgetWithText(
        FgButton,
        LocaleKeys.programmesOpenAssessment.tr(),
      );
      await _show(tester, assessment);
      expect(tester.widget<FgButton>(assessment).isEnabled, isFalse);
      expect(
        find.text(LocaleKeys.compactAssessmentLocked.tr()),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Practice records, reflection validation and root delete at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final record = _historyRecord('latest');
        await _pumpFeature(
          tester,
          const PracticeLogPage(),
          records: [record, _historyRecord('earlier', seconds: 40)],
          textScale: 2,
        );
        final detail = find.byKey(const ValueKey('practice-record-latest'));
        await _show(tester, detail);
        await tester.tap(detail);
        await tester.pumpAndSettle();
        expect(find.text(record.notes), findsOneWidget);
        expect(find.textContaining('+20'), findsOneWidget);
        _expectTopRouteDark(tester);
        final edit = find
            .widgetWithText(FgButton, LocaleKeys.practiceEditReflection.tr())
            .first;
        await _show(tester, edit, delta: -250);
        await tester.tap(edit);
        await tester.pumpAndSettle();
        _expectTopRouteDark(tester);
        final effort = find.byWidgetPredicate(
          (widget) =>
              widget is FgInput && widget.label == LocaleKeys.practiceRpe.tr(),
        );
        await _show(tester, effort);
        await tester.enterText(
          find.descendant(of: effort, matching: find.byType(TextField)),
          '11',
        );
        final save = find.widgetWithText(
          FgButton,
          LocaleKeys.practiceSaveReflection.tr(),
        );
        await _show(tester, save);
        await _tapStorage(tester, save);
        await tester.pumpAndSettle();
        expect(
          find.text(LocaleKeys.practiceReflectionInvalid.tr()),
          findsOneWidget,
        );
        await _show(
          tester,
          find.text(LocaleKeys.practiceReflectionInvalid.tr()),
          delta: -250,
        );
        _expectTopRouteDark(tester);
        await _show(tester, effort, delta: -250);
        await tester.enterText(
          find.descendant(of: effort, matching: find.byType(TextField)),
          '5',
        );
        await _show(tester, save);
        await _tapStorage(tester, save);
        await tester.pumpAndSettle();
        final container = ProviderScope.containerOf(
          tester.element(find.byType(PracticeLogPage)),
        );
        final updated = container
            .read(practiceViewModelProvider)
            .requireValue
            .firstWhere((item) => item.id == record.id);
        expect(updated.durationSeconds, record.durationSeconds);
        expect(updated.bpm, record.bpm);
        expect(updated.performedAt, record.performedAt);
        expect(updated.difficulty, 5);
        final delete = find
            .widgetWithText(FgButton, LocaleKeys.practiceDelete.tr())
            .first;
        await _show(tester, delete, delta: -250);
        await _tapStorage(tester, delete);
        await tester.pumpAndSettle();
        final dialog = find.byType(AlertDialog);
        _expectDarkModal(tester, dialog);
        expect(find.text(LocaleKeys.practiceDeleteBody.tr()), findsOneWidget);
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.practiceCancel.tr()),
        );
        await tester.pumpAndSettle();
        expect(
          container.read(practiceViewModelProvider).requireValue.length,
          2,
        );
        await _tapStorage(tester, delete);
        await tester.pumpAndSettle();
        await _tapStorage(
          tester,
          find.descendant(
            of: find.byType(AlertDialog),
            matching: find.widgetWithText(
              FgButton,
              LocaleKeys.practiceDelete.tr(),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          container
              .read(practiceViewModelProvider)
              .requireValue
              .map((item) => item.id),
          ['earlier'],
        );
        expect(tester.takeException(), isNull);
      },
    );

    testWidgets(
      'Collection populated, draft filters, reset and menu at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const page = CollectionPage();
        await _pumpFeature(
          tester,
          page,
          textScale: 2,
          initialPreferences: _lessonPreferences([
            LessonProgress(
              lessonId: readyBody.lessons.first.id,
              status: LessonStatus.completed,
            ),
            LessonProgress(
              lessonId: readyBody.lessons[1].id,
              status: LessonStatus.inProgress,
            ),
          ]),
        );
        _expectDarkScreen(tester, page);
        await tester.tap(find.byType(FgMenuButton<int>));
        await tester.pumpAndSettle();
        final columns = find.text(LocaleKeys.gridColumns.tr(args: ['4']));
        expect(Theme.of(tester.element(columns)).brightness, Brightness.dark);
        await tester.tap(
          find.byWidgetPredicate(
            (widget) =>
                widget is CheckedPopupMenuItem<int> && widget.value == 4,
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<FgProgramCardLayout>(find.byType(FgProgramCardLayout))
              .maxColumns,
          4,
        );
        final filter = find.byTooltip(LocaleKeys.filterSearch.tr());
        await _show(tester, filter);
        await tester.tap(filter);
        await tester.pumpAndSettle();
        expect(
          Theme.of(tester.element(find.byType(FgFilterSheet))).brightness,
          Brightness.dark,
        );
        final theory = find.widgetWithText(FgFilterChip, 'Theory');
        await tester.ensureVisible(theory);
        await tester.tap(theory);
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.applyFilters.tr()),
        );
        await tester.pumpAndSettle();
        final input = find.byType(TextField);
        await _show(tester, input, delta: -250);
        await tester.enterText(input, 'not a lesson');
        await tester.pumpAndSettle();
        expect(find.text(LocaleKeys.noResults.tr()), findsOneWidget);
        expect(find.text(LocaleKeys.emptyLibraryTitle.tr()), findsNothing);
        await tester.tap(find.byTooltip(LocaleKeys.clearSearch.tr()));
        await tester.pumpAndSettle();
        await tester.tap(filter);
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FgButton, LocaleKeys.reset.tr()));
        await tester.pumpAndSettle();
        await _show(
          tester,
          find.text(readyBody.lessons[1].title.toUpperCase()),
        );
        _expectDarkScreen(tester, page);
      },
    );
  }

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Method dated attempt retains criteria and evidence action at $width / 2x',
      (tester) async {
        final semantics = tester.ensureSemantics();
        try {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final assessment = assessmentById('rhythm-1-v1');
          final repository = _RetryMethodRepository()
            ..progress = MethodProgress(
              attempts: [
                AssessmentAttempt(
                  id: 'dated-evidence',
                  assessmentId: assessment.id,
                  performedAt: DateTime.utc(2026, 9, 7),
                  metCriteriaIds: assessment.criteria
                      .map((item) => item.id)
                      .toList(),
                  notes: 'Comfortable pulse, written reflection.',
                  evidenceId: 'unavailable-local-video',
                  rubricVersion: assessment.rubricVersion,
                ),
              ],
            );
          await _pumpFeature(
            tester,
            const MethodPage(initialCategory: ForgeCategory.rhythm),
            methodRepository: repository,
            textScale: 2,
          );
          final history = find.text(LocaleKeys.methodDatedEvidence.tr());
          await _show(tester, history);
          await tester.tap(history);
          await tester.pumpAndSettle();
          final evidence = find.widgetWithText(
            FgButton,
            LocaleKeys.methodViewEvidence.tr(),
          );
          final title = find.descendant(
            of: find
                .ancestor(of: evidence, matching: find.byType(FgCard))
                .first,
            matching: find.text(assessment.title),
          );
          await _show(tester, title);
          final headingNode = tester.getSemantics(title).getSemanticsData();
          expect(headingNode.label, assessment.title);
          expect(headingNode.hasFlag(SemanticsFlag.isHeader), true);
          expect(headingNode.hasFlag(SemanticsFlag.isButton), false);
          await _show(tester, evidence);
          _expectTopRouteDark(tester);
          expect(evidence.hitTestable(), findsOneWidget);
          expect(
            find.text('Comfortable pulse, written reflection.'),
            findsOneWidget,
          );
          expect(tester.widget<FgButton>(evidence).onPressed, isNotNull);
          final evidenceNode = tester.getSemantics(evidence).getSemanticsData();
          expect(evidenceNode.label, LocaleKeys.methodViewEvidence.tr());
          expect(evidenceNode.hasFlag(SemanticsFlag.isButton), true);
          expect(evidenceNode.hasFlag(SemanticsFlag.isEnabled), true);
          expect(evidenceNode.hasFlag(SemanticsFlag.isHeader), false);
          expect(evidenceNode.hasAction(SemanticsAction.tap), true);
          await tester.runAsync(() async {
            tester.binding.pipelineOwner.semanticsOwner!.performAction(
              tester.getSemantics(evidence).id,
              SemanticsAction.tap,
            );
            await Future<void>.delayed(Duration.zero);
          });
          await tester.pumpAndSettle();
          expect(find.byType(EvidenceViewer), findsOneWidget);
          expect(find.text(LocaleKeys.mediaUnavailable.tr()), findsOneWidget);
          _expectTopRouteDark(tester);
        } finally {
          semantics.dispose();
        }
      },
    );

    testWidgets(
      'Assessment required notes and safety remain visible at $width / 2x',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final assessment = forgeAssessments.firstWhere(
          (item) => item.requiresNotes,
        );
        await _pumpFeature(
          tester,
          MethodPage(initialAssessmentId: assessment.id),
          textScale: 2,
        );
        await _show(
          tester,
          find.text(LocaleKeys.compactMethodAssessmentSafety.tr()),
        );
        _expectTopRouteDark(tester);
        await _show(tester, find.text(LocaleKeys.methodNotesRequired.tr()));
        _expectTopRouteDark(tester);
        await _show(tester, find.text(LocaleKeys.methodIncompletePreview.tr()));
        final save = find.widgetWithText(
          FgButton,
          LocaleKeys.methodSaveAssessment.tr(),
        );
        await _show(tester, save);
        expect(tester.widget<FgButton>(save).isEnabled, isFalse);
      },
    );
  }

  testWidgets('Collection opens actual saved lesson destination', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(path: '/', builder: (_, _) => const CollectionPage()),
        GoRoute(
          path: '/main/module/:moduleId/lesson/:lessonId',
          builder: (_, state) =>
              LessonPlayerScreen(lessonId: state.pathParameters['lessonId']!),
        ),
      ],
    );
    addTearDown(router.dispose);
    await _pumpFeature(
      tester,
      const CollectionPage(),
      router: router,
      initialPreferences: _lessonPreferences([
        LessonProgress(
          lessonId: readyBody.lessons.first.id,
          status: LessonStatus.inProgress,
        ),
      ]),
    );
    final card = find.byType(FgProgramCard);
    await _show(tester, card);
    await tester.tap(card);
    await tester.pumpAndSettle();
    expect(find.byType(LessonPlayerScreen), findsOneWidget);
    expect(
      find.text(readyBody.lessons.first.steps.first.description),
      findsOneWidget,
    );
    _expectTopRouteDark(tester);
  });

  testWidgets(
    'Stats maximum belt is honest rather than an invented next milestone',
    (tester) async {
      late Future<UserStats> stats;
      await tester.runAsync(() async {
        stats = Future.value(
          const UserStats(
            level: 8,
            beltName: 'Black',
            totalXp: 1200,
            streakCount: 3,
            levelProgress: 1,
          ),
        );
      });
      const page = StatsPage();
      await _pumpFeature(tester, page, statsResult: stats);
      await tester.pumpAndSettle();
      await _show(tester, find.text(LocaleKeys.maxLevelReached.tr()));
      _expectDarkScreen(tester, page);
      expect(find.text(LocaleKeys.forgeXpSeparate.tr()), findsOneWidget);
    },
  );

  for (final type in LessonType.values) {
    testWidgets(
      'Lesson ${type.name} all cards retain cues, details and completion at light host',
      (tester) async {
        final module = allModules.firstWhere(
          (module) => module.lessons.any((lesson) => lesson.type == type),
        );
        final lesson = module.lessons.firstWhere(
          (lesson) => lesson.type == type,
        );
        final page = LessonPlayerScreen(lessonId: lesson.id, onBack: () {});
        await _pumpFeature(
          tester,
          page,
          initialPreferences: _lessonPreferences([
            for (final item in allModules.expand((module) => module.lessons))
              if (item.id != lesson.id)
                LessonProgress(
                  lessonId: item.id,
                  status: LessonStatus.completed,
                ),
          ]),
          beforePump: (container) async => container
              .read(learnViewModelProvider.notifier)
              .selectModule(module.id),
        );
        for (final (index, step) in stepsFor(lesson).indexed) {
          await _show(tester, find.text(step.description));
          expect(find.text(step.description).hitTestable(), findsOneWidget);
          // Focus/breath may contain stop signals: they are active guidance,
          // not optional technique copy.
          for (final cue in [
            step.focus,
            step.breath,
          ].where((text) => text.isNotEmpty)) {
            expect(find.text(cue), findsOneWidget);
          }
          await _show(tester, find.text(LocaleKeys.techniqueDetails.tr()));
          await tester.tap(find.text(LocaleKeys.techniqueDetails.tr()));
          await tester.pumpAndSettle();
          for (final cue in [
            step.focus,
            step.breath,
            step.energy,
          ].where((text) => text.isNotEmpty)) {
            await _show(tester, find.text(cue));
            expect(find.text(cue).hitTestable(), findsOneWidget);
            _expectDarkScreen(tester, page);
          }
          if (index < stepsFor(lesson).length - 1) {
            await tester.tap(
              find.widgetWithText(FgButton, LocaleKeys.nextStep.tr()),
            );
            await tester.pumpAndSettle();
          }
        }
        expect(
          find
              .widgetWithText(FgButton, LocaleKeys.completeLesson.tr())
              .hitTestable(),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets(
    'Lesson 1040x400 / 2x can read expanded cues with stable navigation under light host',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(1040, 400));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      final page = LessonPlayerScreen(lessonId: readyBody.lessons.first.id);
      await _pumpFeature(tester, page, textScale: 2);
      final scroll = find.byKey(const ValueKey('lesson-content-scroll'));
      expect(tester.getSize(scroll).height, greaterThan(200));
      final nav = tester.getRect(find.byType(FgStepNavigation));
      await _show(tester, find.text(LocaleKeys.techniqueDetails.tr()));
      await tester.tap(find.text(LocaleKeys.techniqueDetails.tr()));
      await tester.pumpAndSettle();
      await _show(
        tester,
        find.text(readyBody.lessons.first.steps.first.energy),
      );
      _expectDarkScreen(tester, page);
      expect(tester.getRect(find.byType(FgStepNavigation)), nav);
      expect(find.byType(PageView), findsNothing);
    },
  );

  for (final entry in {
    'Module': () => const ModuleViewScreen(),
    'Collection': () => const CollectionPage(),
    'Lesson': () => LessonPlayerScreen(lessonId: readyBody.lessons.first.id),
  }.entries) {
    testWidgets(
      '${entry.key} loading and error are dark with no invented progress',
      (tester) async {
        final repo = _SurfaceProgressRepository();
        late Completer<Map<String, LessonProgress>> pending;
        await tester.runAsync(() async {
          pending = Completer<Map<String, LessonProgress>>();
          repo.nextRead = pending.future;
        });
        final page = entry.value();
        await _pumpFeature(
          tester,
          page,
          progressRepository: repo,
          settle: false,
          waitForLearning: false,
        );
        expect(find.byType(FgSpinner), findsOneWidget);
        _expectDarkScreen(tester, page);
        await tester.runAsync(() async {
          pending.completeError(StateError('unavailable storage'));
          await Future<void>.delayed(Duration.zero);
        });
        await tester.pumpAndSettle();
        expect(
          find.text(LocaleKeys.unexpectedErrorOccurred.tr()),
          findsOneWidget,
        );
        _expectDarkScreen(tester, page);
      },
    );
  }

  testWidgets('Locked lesson retains immersive access boundary', (
    tester,
  ) async {
    final page = LessonPlayerScreen(lessonId: readyBody.lessons[1].id);
    await _pumpFeature(tester, page);
    expect(find.text(LocaleKeys.lockedLabel.tr()), findsOneWidget);
    expect(find.byType(FgStepNavigation), findsNothing);
    _expectDarkScreen(tester, page);
  });

  testWidgets(
    'Method loading error and retry preserve honest no-attempt state',
    (tester) async {
      final repo = _RetryMethodRepository();
      late Completer<MethodProgress> pending;
      const page = MethodPage();
      await _pumpFeature(
        tester,
        page,
        methodRepository: repo,
        settle: false,
        beforePump: (container) async {
          pending = Completer<MethodProgress>();
          repo.nextRead = pending.future;
          unawaited(container.read(methodViewModelProvider.notifier).reload());
        },
      );
      expect(find.byType(FgSpinner), findsOneWidget);
      _expectDarkScreen(tester, page);
      await tester.runAsync(() async {
        pending.completeError(StateError('unavailable storage'));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.methodLoadError.tr()), findsOneWidget);
      _expectDarkScreen(tester, page);
      repo.nextRead = null;
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.methodRetry.tr()),
      );
      await tester.pumpAndSettle();
      final history = find.text(LocaleKeys.methodDatedEvidence.tr());
      await _show(tester, history);
      await tester.tap(history);
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.methodNoAttempts.tr()), findsOneWidget);
    },
  );

  testWidgets(
    'Practice history loading failure retry and no-comparable reflection error',
    (tester) async {
      final repo = _SurfacePracticeRepository()..failUpdate = true;
      late Completer<List<PracticeRecord>> pending;
      const page = PracticeLogPage(lessonId: 'ready-body-1');
      await _pumpFeature(
        tester,
        page,
        practiceRepository: repo,
        records: [_historyRecord('latest')],
        settle: false,
        beforePump: (container) async {
          pending = Completer<List<PracticeRecord>>();
          repo.nextRead = pending.future;
          unawaited(
            container.read(practiceViewModelProvider.notifier).reload(),
          );
        },
      );
      expect(find.byType(FgSpinner), findsOneWidget);
      await tester.runAsync(() async {
        pending.completeError(StateError('unavailable storage'));
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      _expectDarkScreen(tester, page);
      repo.nextRead = null;
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.practiceRetry.tr()),
      );
      await tester.pumpAndSettle();
      expect(
        find.text(LocaleKeys.practiceFilteredHistory.tr()),
        findsOneWidget,
      );
      final details = find.byKey(const ValueKey('practice-record-latest'));
      await _show(tester, details);
      await tester.tap(details);
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.practiceNoComparable.tr()), findsOneWidget);
      final edit = find.widgetWithText(
        FgButton,
        LocaleKeys.practiceEditReflection.tr(),
      );
      await _show(tester, edit, delta: -250);
      await tester.tap(edit);
      await tester.pumpAndSettle();
      final save = find.widgetWithText(
        FgButton,
        LocaleKeys.practiceSaveReflection.tr(),
      );
      await _show(tester, save);
      await _tapStorage(tester, save);
      await tester.pumpAndSettle();
      final failure = find.textContaining('disk full');
      await _show(tester, failure, delta: -250);
      _expectTopRouteDark(tester);
      expect(find.byType(FgInput), findsWidgets);
    },
  );

  testWidgets('Stats loading and failure never substitute invented metrics', (
    tester,
  ) async {
    late Completer<UserStats> pending;
    await tester.runAsync(() async {
      pending = Completer<UserStats>();
    });
    const page = StatsPage();
    await _pumpFeature(tester, page, statsResult: pending.future);
    expect(find.byType(FgSpinner), findsOneWidget);
    _expectDarkScreen(tester, page);
    await tester.runAsync(() async {
      pending.completeError(StateError('unavailable storage'));
      await Future<void>.delayed(Duration.zero);
    });
    await tester.pumpAndSettle();
    expect(find.byType(FgProgressSection), findsNothing);
    _expectDarkScreen(tester, page);
  });

  testWidgets(
    'Module statuses distinguish available, started, completed and locked',
    (tester) async {
      final page = ModuleViewScreen(onLessonNavigate: (_) {});
      await _pumpFeature(tester, page);
      expect(find.text(LocaleKeys.statusInProgress.tr()), findsNothing);
      expect(find.text(LocaleKeys.vocabularyViewLesson.tr()), findsNothing);
      await _openDetails(
        tester,
        find.byKey(ValueKey('module-lessons-${readyBody.id}')),
      );
      await _show(tester, find.text(LocaleKeys.lessonAvailable.tr()));
      final container = ProviderScope.containerOf(
        tester.element(find.byWidget(page)),
      );
      await tester.runAsync(
        () => container
            .read(learnViewModelProvider.notifier)
            .startLesson(readyBody.lessons.first.id),
      );
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.statusInProgress.tr()), findsOneWidget);
      await tester.runAsync(
        () => container
            .read(learnViewModelProvider.notifier)
            .completeLesson(readyBody.lessons.first.id),
      );
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.statusCompleted.tr()), findsOneWidget);
      await _show(tester, find.text(LocaleKeys.lessonAvailable.tr()));
      await _show(tester, find.text(LocaleKeys.lockedLabel.tr()).first);
      final lockedButton = find
          .widgetWithText(FgButton, LocaleKeys.vocabularyViewLesson.tr())
          .last;
      expect(tester.widget<FgButton>(lockedButton).onPressed, isNull);
    },
  );

  testWidgets(
    'Non-first-module lesson retry preserves route identity and final step',
    (tester) async {
      var exits = 0;
      final repository = _SurfaceProgressRepository()..failCompletion = true;
      final module = allModules[1];
      final lesson = module.lessons.first;
      final page = LessonPlayerScreen(
        lessonId: lesson.id,
        onBack: () => exits++,
      );
      await _pumpFeature(
        tester,
        page,
        progressRepository: repository,
        initialPreferences: _lessonPreferences([
          for (final id in module.prerequisiteLessonIds)
            LessonProgress(
              lessonId: id,
              status: LessonStatus.completed,
              progress: 1,
            ),
        ]),
        beforePump: (container) async {
          container
              .read(learnViewModelProvider.notifier)
              .selectModule(module.id);
        },
      );
      for (var index = 1; index < stepsFor(lesson).length; index++) {
        await tester.tap(
          find.widgetWithText(FgButton, LocaleKeys.nextStep.tr()),
        );
        await tester.pumpAndSettle();
      }
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.completeLesson.tr()),
      );
      await tester.pumpAndSettle();
      expect(exits, 0);
      expect(
        find.text(LocaleKeys.unexpectedErrorOccurred.tr()),
        findsOneWidget,
      );
      _expectDarkScreen(tester, page);
      repository.failCompletion = false;
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.methodRetry.tr()),
      );
      await tester.pumpAndSettle();
      expect(find.text(lesson.title.toUpperCase()), findsOneWidget);
      expect(find.text(stepsFor(lesson).last.description), findsOneWidget);
      expect(
        find.widgetWithText(FgButton, LocaleKeys.nextStep.tr()),
        findsNothing,
      );
      await _tapStorage(
        tester,
        find.widgetWithText(FgButton, LocaleKeys.completeLesson.tr()),
      );
      await tester.pumpAndSettle();
      expect(repository.submissions.map((item) => item.lessonId), [
        lesson.id,
        lesson.id,
      ]);
      expect(exits, 1);
      expect(
        (await tester.runAsync(repository.getAll))![lesson.id]!.status,
        LessonStatus.completed,
      );
    },
  );

  testWidgets(
    'Assessment actual submit, failed retry and saving back guard retain identity',
    (tester) async {
      final repository = _RetryMethodRepository();
      final assessment = assessmentById('rhythm-1-v1');
      await _pumpFeature(
        tester,
        const MethodPage(initialCategory: ForgeCategory.rhythm),
        methodRepository: repository,
      );
      await _show(tester, find.text(assessment.title));
      await tester.tap(find.text(assessment.title));
      await tester.pumpAndSettle();
      for (final criterion in assessment.criteria) {
        final checkbox = find.byWidgetPredicate(
          (widget) =>
              widget is FgCheckboxItem &&
              widget.semanticLabel == criterion.text,
        );
        await _show(tester, checkbox);
        await tester.tap(checkbox);
      }
      final confirm = find.byWidgetPredicate(
        (widget) =>
            widget is FgCheckboxItem &&
            widget.semanticLabel == LocaleKeys.methodConfirm.tr(),
      );
      await _show(tester, confirm);
      await tester.tap(confirm);
      final save = find.widgetWithText(
        FgButton,
        LocaleKeys.methodSaveAssessment.tr(),
      );
      await _show(tester, save);
      await _tapStorage(tester, save);
      await tester.pumpAndSettle();
      expect(repository.submissions, hasLength(1));
      await _show(
        tester,
        find.text(LocaleKeys.methodSaveError.tr()),
        delta: -250,
      );
      _expectTopRouteDark(tester);
      await _show(tester, save);
      expect(repository.submissions, hasLength(1));
      repository.fail = false;
      repository.saving = Completer<void>();
      await _tapStorage(tester, save);
      await tester.pump();
      await tester.binding.handlePopRoute();
      await tester.pump();
      expect(
        find.byWidgetPredicate(
          (widget) =>
              widget is FgButton &&
              widget.text == LocaleKeys.methodSaveAssessment.tr() &&
              widget.isLoading,
        ),
        findsOneWidget,
      );
      await tester.runAsync(() async {
        repository.saving!.complete();
        await Future<void>.delayed(Duration.zero);
      });
      await tester.pumpAndSettle();
      expect(repository.submissions[1], same(repository.submissions[0]));
      final history = find.text(LocaleKeys.methodDatedEvidence.tr());
      await _show(tester, history);
      await tester.tap(history);
      await tester.pumpAndSettle();
      expect(find.textContaining(LocaleKeys.methodPassed.tr()), findsWidgets);
      _expectTopRouteDark(tester);
    },
  );
}
