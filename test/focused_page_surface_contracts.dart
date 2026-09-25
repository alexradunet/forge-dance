part of 'feature_surface_contract_test.dart';

void _focusedPageSurfaceContracts() {
  for (final scale in [1.0, 2.0]) {
    testWidgets('Full programme schedule is opt-in at ${scale}x', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 844));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await _pumpFeature(tester, const ProgrammesPage(), textScale: scale);
      final programme = forgeProgrammes.firstWhere(
        (p) => p.id == 'movement-foundations',
      );
      final preview = find.byKey(ValueKey('programme-preview-${programme.id}'));
      await _show(tester, preview);
      await tester.tap(preview);
      await tester.pumpAndSettle();
      expect(find.text(LocaleKeys.programmesStart.tr()), findsOneWidget);
      expect(
        find.text(LocaleKeys.programmesPracticeSession.tr()),
        findsNothing,
      );
      expect(find.text(LocaleKeys.programmesOpenAssessment.tr()), findsNothing);
      expect(
        find.byKey(
          ValueKey('programme-session-${programme.sessions.last.lessonId}'),
        ),
        findsNothing,
      );
      final schedule = find.byKey(
        ValueKey('programme-schedule-${programme.id}'),
      );
      await _openDetails(tester, schedule);
      for (final session in programme.sessions) {
        expect(
          find.byKey(ValueKey('programme-session-${session.lessonId}')),
          findsOneWidget,
        );
      }
      await _show(
        tester,
        find.byKey(
          ValueKey('programme-session-${programme.sessions.last.lessonId}'),
        ),
      );
      _expectTopRouteDark(tester);
      // Collapsing the schedule restores the short default, without changing enrolment.
      await _openDetails(tester, schedule);
      expect(
        find.byKey(
          ValueKey('programme-session-${programme.sessions.last.lessonId}'),
        ),
        findsNothing,
      );
      await _show(tester, find.text(LocaleKeys.programmesStart.tr()));
      expect(
        find.text(LocaleKeys.programmesStart.tr()).hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
    });

    testWidgets(
      'Belt reference is opt-in without nested disclosures at ${scale}x',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 844));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        const page = MethodPage();
        await _pumpFeature(tester, page, textScale: scale);
        expect(find.byKey(const ValueKey('belt-0')), findsNothing);
        final belts = find.byKey(const ValueKey('method-belt-requirements'));
        await _openDetails(tester, belts);
        for (final belt in forgeBelts) {
          expect(
            find.descendant(
              of: find.byKey(ValueKey('belt-${belt.index}')),
              matching: find.text(belt.description),
            ),
            findsOneWidget,
          );
        }
        expect(
          find.descendant(of: belts, matching: find.byType(FgDetails)),
          findsNothing,
        );
        expect(find.text(LocaleKeys.methodOpenIntegrated.tr()), findsWidgets);
        await _show(tester, find.text(forgeBelts.last.description));
        _expectDarkScreen(tester, page);
        await _openDetails(tester, belts);
        expect(find.byKey(const ValueKey('belt-0')), findsNothing);
        final category = find.byWidgetPredicate((widget) =>
          widget is FgProgramCard && widget.title == ForgeCategory.rhythm.label);
        await _show(tester, category, delta: -250);
        await tester.tap(category);
        await tester.pumpAndSettle();
        expect(
          tester
              .widget<MethodPage>(find.byType(MethodPage).last)
              .initialCategory,
          ForgeCategory.rhythm,
        );
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Completed programme exposes final assessment without opening details',
    (tester) async {
      final programme = forgeProgrammes.first;
      await _pumpFeature(
        tester,
        const ProgrammesPage(),
        initialPreferences: _lessonPreferences([
          for (final session in programme.sessions)
            LessonProgress(
              lessonId: session.lessonId,
              status: LessonStatus.completed,
            ),
        ]),
      );
      await _openProgramme(tester);
      expect(
        find.text(LocaleKeys.programmesOpenAssessment.tr()),
        findsOneWidget,
      );
      expect(find.text(LocaleKeys.programmesNextSession.tr()), findsNothing);
      final assessment = find.widgetWithText(
        FgButton,
        LocaleKeys.programmesOpenAssessment.tr(),
      );
      await _show(tester, assessment);
      expect(tester.widget<FgButton>(assessment).isEnabled, isTrue);
      await tester.tap(assessment);
      await tester.pumpAndSettle();
      expect(find.byType(MethodPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Daily preview and alternate destinations stay out of the default view',
    (tester) async {
      const page = PracticePage();
      await _pumpFeature(tester, page);
      final container = ProviderScope.containerOf(
        tester.element(find.byType(PracticePage)),
      );
      final plan = container.read(dailyPracticePlanProvider)!;
      expect(find.text(plan.blocks.first.title), findsNothing);
      expect(find.text(LocaleKeys.compactLogbook.tr()), findsNothing);
      final rounds = find.byKey(ValueKey('practice-rounds-${plan.dateKey}'));
      await _openDetails(tester, rounds);
      for (final block in plan.blocks) {
        expect(find.text(block.title), findsOneWidget);
        expect(find.text(block.adaptation), findsWidgets);
      }
      expect(
        find.descendant(of: rounds, matching: find.byType(FgDetails)),
        findsNothing,
      );
      await _openDetails(tester, rounds);
      await _openDetails(tester, find.byKey(const ValueKey('practice-other')));
      final log = find.widgetWithText(FgButton, LocaleKeys.compactLogbook.tr());
      await _show(tester, log);
      await tester.tap(log);
      await tester.pumpAndSettle();
      expect(find.byType(PracticeLogPage), findsOneWidget);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'Real module and lesson routes do not mutate providers during build',
    (tester) async {
      final module = allModules[1];
      late ProviderContainer container;
      await _pumpFeature(
        tester,
        const SizedBox.shrink(),
        useProductionRouter: true,
        initialPreferences: {
          Constants.profileKey: jsonEncode(
            const Profile(name: 'Dancer').toJson(),
          ),
          ..._lessonPreferences([
            for (final m in allModules)
              for (final lesson in m.lessons)
                if (lesson.id != module.lessons.first.id)
                  LessonProgress(
                    lessonId: lesson.id,
                    status: LessonStatus.completed,
                  ),
          ]),
        },
        beforePump: (value) async {
          container = value;
          container
              .read(app_router.routerProvider)
              .go(ModuleDestination(module.id).location);
        },
      );
      expect(find.byType(ModuleViewScreen), findsOneWidget);
      expect(find.text(module.title), findsOneWidget);
      expect(find.text(module.lessons.first.title), findsOneWidget);
      expect(
        container.read(learnViewModelProvider).requireValue.activeModuleId,
        allModules.first.id,
      );
      expect(tester.takeException(), isNull);
      final next = find.widgetWithText(FgButton, LocaleKeys.continueText.tr());
      await _show(tester, next);
      await _tapStorage(tester, next);
      await tester.pumpAndSettle();
      expect(find.byType(LessonPlayerScreen), findsOneWidget);
      expect(
        tester
            .widget<LessonPlayerScreen>(find.byType(LessonPlayerScreen))
            .lessonId,
        module.lessons.first.id,
      );
      expect(tester.takeException(), isNull);
    },
  );
}
