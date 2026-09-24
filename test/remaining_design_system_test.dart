import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

double contrast(Color a, Color b) =>
    (math.max(a.computeLuminance(), b.computeLuminance()) + .05) /
    (math.min(a.computeLuminance(), b.computeLuminance()) + .05);

void main() {
  for (final theme in [
    AppThemes.light,
    AppThemes.dark,
    AppThemes.highContrastLight,
    AppThemes.highContrastDark,
  ]) {
    testWidgets(
      'Badge status/category contrast ${theme.brightness} ${theme.colorScheme.primary}',
      (tester) async {
        await tester.pumpWidget(
          MaterialApp(
            theme: theme,
            home: Scaffold(
              body: Wrap(
                children: [
                  for (final color in FgBadgeColor.values)
                    for (final variant in FgBadgeVariant.values)
                      FgBadge(
                        text: '${color.name} ${variant.name}',
                        color: color,
                        variant: variant,
                      ),
                ],
              ),
            ),
          ),
        );
        for (final badge in find.byType(FgBadge).evaluate()) {
          final decoration =
              tester
                      .widget<DecoratedBox>(
                        find.descendant(
                          of: find.byWidget(badge.widget),
                          matching: find.byType(DecoratedBox),
                        ),
                      )
                      .decoration
                  as BoxDecoration;
          final text = tester.widget<Text>(
            find.descendant(
              of: find.byWidget(badge.widget),
              matching: find.byType(Text),
            ),
          );
          final backing = Color.alphaBlend(
            decoration.color!,
            theme.scaffoldBackgroundColor,
          );
          expect(
            contrast(text.style!.color!, backing),
            greaterThanOrEqualTo(4.5),
            reason: text.data,
          );
        }
        expect(tester.takeException(), isNull);
      },
    );
  }
  testWidgets(
    'Shared root alert is dark, scrollable at 2x and cancels/confirms',
    (tester) async {
      await tester.binding.setSurfaceSize(const Size(320, 640));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      bool? result;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: TextScaler.linear(2)),
            child: child!,
          ),
          home: Scaffold(
            body: Builder(
              builder: (context) => TextButton(
                onPressed: () async {
                  result = await ForgeAlertDialog.show(
                    context: context,
                    title: 'Remove local recording?',
                    message: 'This removes the recording from this device. Existing references will no longer play it.',
                    primaryActionLabel: 'Remove recording',
                    secondaryActionLabel: 'Keep recording',
                    isPrimaryDestructive: true,
                  );
                },
                child: const Text('Open'),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      final dialog = tester.element(find.byType(AlertDialog));
      expect(Theme.of(dialog).brightness, Brightness.dark);
      await tester.tap(find.text('Keep recording'));
      await tester.pumpAndSettle();
      expect(result, false);
      await tester.tap(find.text('Open'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Remove recording'));
      await tester.pumpAndSettle();
      expect(result, true);
      expect(tester.takeException(), isNull);
    },
  );
  testWidgets('Navigation button supports keyboard and selected semantics', (
    tester,
  ) async {
    var taps = 0;
    final semantics = tester.ensureSemantics();
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FgNavButton(
            icon: Icons.home,
            label: 'Home',
            isActive: true,
            onTap: () => taps++,
          ),
        ),
      ),
    );
    await tester.tap(find.text('Home'));
    expect(taps, 1);
    expect(
      tester.getSemantics(find.byType(FgNavButton)),
      matchesSemantics(
        isButton: true,
        hasEnabledState: true,
        isEnabled: true,
        isFocusable: true,
        hasTapAction: true,
        hasFocusAction: true,
        hasSelectedState: true,
        isSelected: true,
        label: 'Home',
      ),
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(taps, 2);
    semantics.dispose();
  });
}
