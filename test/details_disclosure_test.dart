import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets(
    'secondary copy is recoverable through accessible expand and collapse',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.light,
            home: FgImmersiveScaffold(
              bodyBuilder: (_) => ListView(
                children: const [
                  FgDetails(
                    title: 'Technique and context',
                    child: Text(
                      'Complete technique explanation, retained without truncation.',
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
        expect(
          find.text(
            'Complete technique explanation, retained without truncation.',
          ),
          findsNothing,
        );
        final collapsed = tester.getSemantics(
          find.text('Technique and context'),
        );
        expect(
          collapsed.getSemanticsData().hasAction(SemanticsAction.tap),
          isTrue,
        );
        expect(
          tester.getSize(find.byType(ExpansionTile)).height,
          greaterThanOrEqualTo(48),
        );
        await tester.tap(find.text('Technique and context'));
        await tester.pumpAndSettle();
        expect(
          find
              .text(
                'Complete technique explanation, retained without truncation.',
              )
              .hitTestable(),
          findsOneWidget,
        );
        await tester.tap(find.text('Technique and context'));
        await tester.pumpAndSettle();
        expect(
          find.text(
            'Complete technique explanation, retained without truncation.',
          ),
          findsNothing,
        );
      } finally {
        semantics.dispose();
      }
    },
  );

  testWidgets(
    'expanded state can retain an optional form without losing entered data',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: FgImmersiveScaffold(
            bodyBuilder: (_) => ListView(
              children: const [
                FgDetails(
                  title: 'Optional reflection',
                  maintainState: true,
                  child: TextField(),
                ),
              ],
            ),
          ),
        ),
      );
      await tester.tap(find.text('Optional reflection'));
      await tester.pumpAndSettle();
      await tester.enterText(find.byType(TextField), 'Keep my reflection');
      await tester.tap(find.text('Optional reflection'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Optional reflection'));
      await tester.pumpAndSettle();
      expect(find.text('Keep my reflection').hitTestable(), findsOneWidget);
    },
  );

  testWidgets('large text and reduced motion keep details reachable', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 640));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(
            context,
          ).copyWith(disableAnimations: true, textScaler: TextScaler.linear(2)),
          child: child!,
        ),
        home: FgImmersiveScaffold(
          bodyBuilder: (_) => ListView(
            children: const [
              FgDetails(
                title: 'Adaptations and comfortable movement choices',
                child: Text('Use the complete explanation at your own pace.'),
              ),
            ],
          ),
        ),
      ),
    );
    await tester.tap(find.text('Adaptations and comfortable movement choices'));
    await tester.pump();
    expect(
      find.text('Use the complete explanation at your own pace.').hitTestable(),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
