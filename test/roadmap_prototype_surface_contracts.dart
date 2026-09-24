part of 'feature_surface_contract_test.dart';

// Integration safety net for the debug-only preview, not production acceptance
// of any of the three proposed designs.
void _roadmapPrototypeSurfaceContracts() {
  for (final variant in roadmapPrototypeVariants) {
    for (final scale in [1.0, 2.0]) {
      testWidgets(
        'roadmap preview $variant at $scale is readable and read-only',
        (tester) async {
          await tester.binding.setSurfaceSize(const Size(390, 1000));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          final router = GoRouter(
            initialLocation: '${Routes.explore}?variant=$variant',
            routes: [
              GoRoute(
                path: Routes.explore,
                builder: (_, state) => LearningRoadmapPrototype(
                  variant: state.uri.queryParameters['variant']!,
                ),
              ),
            ],
          );
          addTearDown(router.dispose);
          final page = LearningRoadmapPrototype(variant: variant);
          await _pumpFeature(tester, page, router: router, textScale: scale);
          _expectDarkScreen(
            tester,
            tester.widget<LearningRoadmapPrototype>(
              find.byType(LearningRoadmapPrototype),
            ),
          );
          final container = ProviderScope.containerOf(
            tester.element(find.byType(LearningRoadmapPrototype)),
          );
          final before = container
              .read(learnViewModelProvider)
              .requireValue
              .progress;
          final enrolments = container
              .read(programmesViewModelProvider)
              .requireValue;
          final focus = find.byKey(const ValueKey('roadmap-focus'));
          await _show(tester, focus);
          await tester.tap(focus);
          await tester.pumpAndSettle();
          final choose = find.widgetWithText(FgButton, 'Find the Beat');
          await tester.ensureVisible(choose);
          await tester.tap(choose);
          await tester.pumpAndSettle();
          expect(find.text('Focus: Find the Beat'), findsOneWidget);
          // A new focus highlights existing lessons without recording enrolment.
          final browse = find.widgetWithText(FgFilterChip, 'Browse lessons');
          await _show(tester, browse, delta: -250);
          await tester.tap(browse);
          await tester.pumpAndSettle();
          final input = find.byType(TextField);
          await _show(tester, input);
          await tester.enterText(input, 'Ready Body');
          await tester.pumpAndSettle();
          final details = find.text('Lessons & prerequisites');
          await _show(tester, details);
          await tester.tap(details);
          await tester.pumpAndSettle();
          final lesson = find.widgetWithText(
            FgButton,
            'Focus · Space & Signals',
          );
          await _show(tester, lesson);
          await tester.tap(lesson);
          await tester.pumpAndSettle();
          expect(find.text('Available to study'), findsOneWidget);
          final dialog = find.byType(AlertDialog);
          final dialogTheme = Theme.of(tester.element(dialog));
          expect(
            dialogTheme.colorScheme.surface.computeLuminance(),
            lessThan(0.1),
          );
          _expectReadableText(tester, dialog, dialogTheme.colorScheme.surface);
          await tester.tap(find.text('Back to roadmap'));
          await tester.pumpAndSettle();
          expect(
            container.read(learnViewModelProvider).requireValue.progress,
            before,
          );
          expect(
            container.read(programmesViewModelProvider).requireValue,
            enrolments,
          );
          await tester.tap(find.byTooltip('Next layout'));
          await tester.pumpAndSettle();
          expect(
            router
                .routeInformationProvider
                .value
                .uri
                .queryParameters['variant'],
            roadmapPrototypeVariants[(roadmapPrototypeVariants.indexOf(
                      variant,
                    ) +
                    1) %
                3],
          );
          expect(tester.takeException(), isNull);
        },
      );
    }
  }
}
