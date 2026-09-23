import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets('disabled primary labels remain readable on immersive surfaces', (
    tester,
  ) async {
    for (final theme in [AppThemes.light, AppThemes.dark]) {
      var invoked = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: theme,
          home: FgImmersiveScaffold(
            bodyBuilder: (_) => Center(
              child: FgButton(
                text: 'Locked practice',
                isEnabled: false,
                onPressed: () => invoked = true,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(
        tester.widget<Text>(find.text('Locked practice')).style!.color,
        AppThemes.dark.forgeColors.onImmersiveMuted,
      );
      await tester.tap(find.text('Locked practice'));
      expect(invoked, isFalse);
    }
  });

  testWidgets(
    'reference is one readable native keyboard destination in all themes',
    (tester) async {
      final semantics = tester.ensureSemantics();
      for (final theme in [
        AppThemes.light,
        AppThemes.dark,
        AppThemes.highContrastLight,
        AppThemes.highContrastDark,
      ]) {
        final focus = FocusNode();
        var opened = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: FgReferenceCard(
                indexLabel: '01',
                title: 'Bounce',
                label: 'Moves · Hip hop',
                definition: 'A relaxed bending and releasing action.',
                status: 'Not explored in lessons yet',
                focusNode: focus,
                onTap: () => opened++,
              ),
            ),
          ),
        );
        focus.requestFocus();
        await tester.pumpAndSettle();
        final data = tester
            .getSemantics(find.byType(FgCard))
            .getSemanticsData();
        expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
        expect(data.label, contains('Bounce'));
        expect(data.label, contains('Not explored in lessons yet'));
        expect(find.byType(InkWell), findsOneWidget);
        expect(
          tester.widget<Text>(find.text('Bounce')).style!.color,
          theme.forgeColors.onImmersive,
        );
        expect(
          tester
              .widget<Text>(
                find.text('A relaxed bending and releasing action.'),
              )
              .style!
              .color,
          theme.forgeColors.onImmersiveMuted,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        await tester.sendKeyEvent(LogicalKeyboardKey.space);
        await tester.pumpAndSettle();
        expect(opened, 2);
        expect(tester.takeException(), isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        focus.dispose();
      }
      semantics.dispose();
    },
  );

  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'practice meter reflows at $width with reduced motion and 2x text',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        final semantics = tester.ensureSemantics();
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.light,
            builder: (context, child) => MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(2),
                disableAnimations: true,
                highContrast: true,
              ),
              child: child!,
            ),
            home: FgImmersiveScaffold(
              bodyBuilder: (_) => const SingleChildScrollView(
                padding: AppSpacing.allLG,
                child: FgPracticeMeter(
                  elapsed: '02:15',
                  elapsedSemanticLabel: '135 active practice seconds',
                  target: 'Target: 3 min',
                  status: 'Count 3',
                  metadata: '60 BPM · counts 3–6',
                  progress: 0.75,
                  activeCount: 3,
                  firstCount: 3,
                  lastCount: 6,
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          find.bySemanticsLabel('135 active practice seconds'),
          findsOneWidget,
        );
        expect(find.text('Count 3'), findsOneWidget);
        final active = tester.widget<DecoratedBox>(
          find.byKey(const ValueKey('practice-count-3')),
        );
        expect(
          (active.decoration as BoxDecoration).color,
          AppThemes.highContrastDark.colorScheme.primary,
        );
        final strip = find.descendant(
          of: find.byType(Wrap),
          matching: find.byType(Text),
        );
        expect(strip, findsNWidgets(8));
        expect(
          tester.widget<Text>(find.text('1')).style!.decoration,
          TextDecoration.lineThrough,
        );
        expect(
          tester.widget<Text>(find.text('3')).style!.color,
          AppThemes.highContrastDark.colorScheme.onPrimary,
        );
        expect(tester.binding.hasScheduledFrame, isFalse);
        expect(tester.takeException(), isNull);
        semantics.dispose();
      },
    );
  }
}
