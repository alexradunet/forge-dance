import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets(
    'editorial route card is one selected keyboard action in every theme',
    (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        for (final theme in [
          AppThemes.light,
          AppThemes.dark,
          AppThemes.highContrastLight,
          AppThemes.highContrastDark,
        ]) {
          var opened = 0;
          final focusNode = FocusNode();
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: Scaffold(
                body: FgProgramCard(
                  title: 'Find the Beat',
                  label: 'ROUTE 01 • Enrolled',
                  summary: 'Build a safe base and locate a steady pulse.',
                  details: '0 of 6 lessons studied',
                  actionLabel: 'Continue programme',
                  isSelected: true,
                  focusNode: focusNode,
                  onTap: () => opened++,
                ),
              ),
            ),
          );
          focusNode.requestFocus();
          await tester.pumpAndSettle();
          expect(find.byType(FgImage), findsNothing);
          expect(find.byType(InkWell), findsOneWidget);
          final data = tester
              .getSemantics(find.byType(FgCard))
              .getSemanticsData();
          expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
          expect(data.hasFlag(SemanticsFlag.isSelected), isTrue);
          expect(data.label, contains('Continue programme'));
          final material = tester.widget<Material>(
            find.descendant(
              of: find.byType(FgCard),
              matching: find.byType(Material),
            ),
          );
          expect(
            (material.shape! as RoundedRectangleBorder).borderRadius,
            AppBorderRadius.small,
          );
          await tester.sendKeyEvent(LogicalKeyboardKey.enter);
          await tester.pumpAndSettle();
          expect(opened, 1);
          await tester.sendKeyEvent(LogicalKeyboardKey.space);
          await tester.pumpAndSettle();
          expect(opened, 2);
          expect(tester.takeException(), isNull);
          await tester.pumpWidget(const SizedBox.shrink());
          focusNode.dispose();
        }
      } finally {
        semantics.dispose();
      }
    },
  );

  for (final columns in [1, 2, 4]) {
    testWidgets(
      'requested column cap $columns preserves full card content and action',
      (tester) async {
        await tester.binding.setSurfaceSize(const Size(1280, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var opened = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.light,
            home: FgImmersiveScaffold(
              bodyBuilder: (context) => SingleChildScrollView(
                child: FgProgramCardLayout(
                  maxColumns: columns,
                  children: [
                    for (var index = 0; index < 4; index++)
                      FgProgramCard(
                        title: 'Lesson $index',
                        label: 'Completed',
                        summary: 'Complete reading content without a fixed-height grid.',
                        onTap: () => opened++,
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
        final cards = find.byType(FgProgramCard);
        expect(
          tester.getSize(cards.first).width,
          closeTo((1280 - AppSpacing.lg * (columns - 1)) / columns, .01),
        );
        await tester.ensureVisible(cards.last);
        await tester.tap(cards.last);
        expect(opened, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  for (final width in [320.0, 1024.0]) {
    testWidgets('program cards adapt at $width with large text', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(Size(width, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      var opened = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.dark,
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(
                size: Size(width, 900),
                textScaler: TextScaler.linear(2),
              ),
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppSpacing.screen,
                  child: FgProgramCardLayout(
                    children: [
                      FgProgramCard(
                        title: 'Ready body',
                        imageUrl: 'https://example.com/one.png',
                        label: 'Start here',
                        details: '0 of 3 lessons',
                        progress: 0,
                        onTap: () => opened = true,
                      ),
                      FgProgramCard(
                        title: 'Time and weight',
                        imageUrl: 'https://example.com/two.png',
                        label: 'Locked',
                        details: 'Requires Bases & Breath',
                        locked: true,
                        progress: 0.5,
                        onTap: () {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      expect(tester.takeException(), isNull);
      expect(find.byType(FgProgressBar), findsOneWidget);
      final cards = find.byType(FgProgramCard);
      final first = tester.getTopLeft(cards.at(0));
      final second = tester.getTopLeft(cards.at(1));
      if (width < 600) {
        expect(second.dy, greaterThan(first.dy));
      } else {
        expect(second.dy, first.dy);
        expect(second.dx, greaterThan(first.dx));
      }
      await tester.ensureVisible(find.text('READY BODY'));
      await tester.tap(find.text('READY BODY'));
      expect(opened, isTrue);
      expect(tester.takeException(), isNull);
    });
  }
}
