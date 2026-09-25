part of 'feature_surface_contract_test.dart';

// Preview integration safety, not approval of the fictional reward economy.
void _skillPrototypeSurfaceContracts() {
  GoRouter routerFor(String variant) => GoRouter(
    initialLocation: '${Routes.profile}?variant=$variant',
    routes: [
      GoRoute(
        path: Routes.profile,
        builder: (_, state) => SkillProgressionPrototype(
          variant: state.uri.queryParameters['variant'] ?? 'skills',
        ),
      ),
      GoRoute(
        path: Routes.explore,
        builder: (_, state) => LearningRoadmapPrototype(
          variant: 'roadmap',
          initialSearch: state.uri.queryParameters['search'],
        ),
      ),
    ],
  );

  void expectSurface(WidgetTester tester) => _expectDarkScreen(
    tester,
    tester.widget<FgImmersiveScaffold>(find.byType(FgImmersiveScaffold).last),
  );

  for (final variant in skillPrototypeVariants) {
    for (final scale in [1.0, 2.0]) {
      testWidgets('skill preview $variant remains readable at $scale', (
        tester,
      ) async {
        await tester.binding.setSurfaceSize(const Size(390, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final router = routerFor(variant);
        addTearDown(router.dispose);
        await _pumpFeature(
          tester,
          SkillProgressionPrototype(variant: variant),
          router: router,
          textScale: scale,
        );
        expectSurface(tester);
        expect(
          find.text('Prototype · fictional sample data · nothing saved'),
          findsOneWidget,
        );
        await tester.tap(find.byTooltip('Next skill layout'));
        await tester.pumpAndSettle();
        expect(
          router.routeInformationProvider.value.uri.queryParameters['variant'],
          skillPrototypeVariants[(skillPrototypeVariants.indexOf(variant) + 1) %
              3],
        );
        expectSurface(tester);
      });
    }
  }

  for (final scale in [1.0, 2.0]) {
    testWidgets(
      'skill demo rewards, evidence and quest keep real storage untouched at $scale',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(390, 1000));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final router = routerFor('skills');
        addTearDown(router.dispose);
        await _pumpFeature(
          tester,
          const SkillProgressionPrototype(variant: 'skills'),
          router: router,
          textScale: scale,
        );
        final prefs = await SharedPreferences.getInstance();
        final before = {for (final key in prefs.getKeys()) key: prefs.get(key)};
        final session = find.text('Preview session rewards');
        await _show(tester, session);
        await tester.tap(session);
        await tester.pumpAndSettle();
        expectSurface(tester);
        await _show(tester, find.text('Level 24 → 25'));
        expect(find.text('Level 24 → 25'), findsOneWidget);
        final apply = find.byKey(const ValueKey('apply-demo-session'));
        await _show(tester, apply);
        await tester.tap(apply);
        await tester.pumpAndSettle();
        expect(tester.widget<FgButton>(apply).onPressed, isNull);
        await tester.tap(find.text('Back to skills'));
        await tester.pumpAndSettle();
        final rhythm = find.byKey(const ValueKey('demo-skill-rhythm'));
        await _show(tester, rhythm);
        await tester.tap(rhythm);
        await tester.pumpAndSettle();
        expectSurface(tester);
        expect(find.text('Level 25 / 99'), findsOneWidget);
        final evidence = find.text('Add demo self-assessment');
        await _show(tester, evidence);
        await tester.tap(evidence);
        await tester.pumpAndSettle();
        await _show(tester, find.text('Level 25 / 99'), delta: -250);
        expect(find.text('Level 25 / 99'), findsOneWidget);
        final explain = find.text('How levels & milestones differ');
        await _show(tester, explain);
        await tester.tap(explain);
        await tester.pumpAndSettle();
        final dialog = find.byType(AlertDialog);
        final theme = Theme.of(tester.element(dialog));
        expect(theme.colorScheme.surface.computeLuminance(), lessThan(0.1));
        _expectReadableText(tester, dialog, theme.colorScheme.surface);
        await tester.tap(find.text('Got it'));
        await tester.pumpAndSettle();
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        final quest = find.text('Find Your Groove quest');
        await _show(tester, quest, delta: -250);
        await tester.tap(quest);
        await tester.pumpAndSettle();
        expectSurface(tester);
        final locate = find.byKey(const ValueKey('locate-quest-0'));
        await _show(tester, locate);
        await tester.tap(locate);
        await tester.pumpAndSettle();
        expect(find.byType(LearningRoadmapPrototype), findsOneWidget);
        expect(
          tester.widget<TextField>(find.byType(TextField)).controller!.text,
          'Find Pulse',
        );
        await tester.binding.handlePopRoute();
        await tester.pumpAndSettle();
        final claim = find.byKey(const ValueKey('claim-demo-quest'));
        // Disabled before any simulated completion.
        await _show(tester, claim);
        expect(tester.widget<FgButton>(claim).onPressed, isNull);
        for (var index = 0; index < 5; index++) {
          final step = find.byKey(ValueKey('demo-quest-step-$index'));
          await _show(tester, step, delta: index == 0 ? -250 : 250);
          await tester.tap(step);
          await tester.pumpAndSettle();
        }
        await _show(tester, claim);
        await tester.tap(claim);
        await tester.pumpAndSettle();
        expect(tester.widget<FgButton>(claim).onPressed, isNull);
        expect({
          for (final key in prefs.getKeys()) key: prefs.get(key),
        }, before);
        expect(tester.takeException(), isNull);
      },
    );
  }
}
