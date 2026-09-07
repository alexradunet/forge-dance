import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

Color textColor(WidgetTester tester, String text) => tester
    .widget<RichText>(
      find.descendant(of: find.text(text), matching: find.byType(RichText)),
    )
    .text
    .style!
    .color!;

double contrast(Color a, Color b) {
  final first = a.computeLuminance();
  final second = b.computeLuminance();
  return (math.max(first, second) + 0.05) / (math.min(first, second) + 0.05);
}

void main() {
  testWidgets(
    'immersive forms and root dialogs remain dark under a light device theme',
    (tester) async {
      var selected = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: FgImmersiveScaffold(
            title: 'Movement profile',
            bodyBuilder: (context) => ListView(
              children: [
                FgCard(
                  immersive: true,
                  child: Text(
                    'Current capability',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                StatefulBuilder(
                  builder: (context, update) => SwitchListTile(
                    title: const Text('Gentler practice'),
                    value: selected,
                    onChanged: (value) => update(() => selected = value),
                  ),
                ),
                const ExpansionTile(
                  title: Text('Requirements'),
                  children: [Text('Keep a comfortable pulse')],
                ),
                FgButton(
                  text: 'Open confirmation',
                  onPressed: () => FgImmersiveScaffold.showModal<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Private evidence'),
                      content: const Text(
                        'Keep your recording on this device.',
                      ),
                      actions: [
                        FgButton(
                          text: 'Close confirmation',
                          onPressed: () => Navigator.pop(context),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      final cardColor = tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(FgCard),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color!;
      expect(cardColor.computeLuminance(), lessThan(0.1));
      expect(
        contrast(cardColor, textColor(tester, 'Current capability')),
        greaterThanOrEqualTo(4.5),
      );
      await tester.tap(find.byType(SwitchListTile));
      await tester.pumpAndSettle();
      expect(selected, isTrue);
      await tester.tap(find.text('Requirements'));
      await tester.pumpAndSettle();
      expect(
        find.text('Keep a comfortable pulse').hitTestable(),
        findsOneWidget,
      );
      expect(tester.takeException(), isNull);
      await tester.tap(find.text('Open confirmation'));
      await tester.pumpAndSettle();
      final dialogColor = tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(AlertDialog),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color!;
      expect(dialogColor.computeLuminance(), lessThan(0.1));
      expect(
        contrast(dialogColor, textColor(tester, 'Private evidence')),
        greaterThanOrEqualTo(4.5),
      );
      await tester.tap(find.text('Close confirmation'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    },
  );

  testWidgets(
    'large high-contrast text remains readable without overriding ambient appearance',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: MediaQuery(
            data: const MediaQueryData(
              highContrast: true,
              textScaler: TextScaler.linear(2),
            ),
            child: FgImmersiveScaffold(
              title: 'Assess your movement',
              bodyBuilder: (context) => ListView(
                children: [
                  FgCard(
                    immersive: true,
                    child: Text(
                      'Adapt the movement to your available range.',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      final cardColor = tester
          .widget<Material>(
            find
                .descendant(
                  of: find.byType(FgCard),
                  matching: find.byType(Material),
                )
                .first,
          )
          .color!;
      expect(
        contrast(
          cardColor,
          textColor(tester, 'Adapt the movement to your available range.'),
        ),
        greaterThanOrEqualTo(7),
      );
      expect(
        Theme.of(tester.element(find.byType(FgImmersiveScaffold))).brightness,
        Brightness.light,
      );
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets(
    'editorial back action honors unsaved-work navigation protection',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: Builder(
            builder: (context) => Scaffold(
              body: FgButton(
                text: 'Open protected practice',
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute<void>(
                    builder: (_) => PopScope(
                      canPop: false,
                      child: FgImmersiveScaffold(
                        title: 'Practice',
                        bodyBuilder: (_) => const Text('Unsaved practice'),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      await tester.tap(find.text('Open protected practice'));
      await tester.pumpAndSettle();
      await tester.tap(find.byTooltip('Back'));
      await tester.pumpAndSettle();
      expect(find.text('Unsaved practice'), findsOneWidget);
      expect(find.text('Open protected practice').hitTestable(), findsNothing);
    },
  );
}
