import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  for (final width in [320.0, 1040.0]) {
    testWidgets(
      'Reading body constrains scrolling and keyboard actions at $width',
      (tester) async {
        await tester.binding.setSurfaceSize(Size(width, 900));
        addTearDown(() => tester.binding.setSurfaceSize(null));
        var calls = 0;
        await tester.pumpWidget(
          MaterialApp(
            theme: AppThemes.light,
            home: Scaffold(
              body: MediaQuery(
                data: MediaQueryData(textScaler: TextScaler.linear(2)),
                child: FgReadingBody(
                  child: ListView(
                    children: [
                      const FgSectionHeading(
                        title: 'A full editorial heading that wraps',
                      ),
                      FgButton(
                        text: 'Continue reading',
                        autofocus: true,
                        onPressed: () => calls++,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
        await tester.pumpAndSettle();
        expect(
          tester.getSize(find.byType(ListView)).width,
          width < AppSizes.readingContentMax
              ? width
              : AppSizes.readingContentMax,
        );
        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        await tester.pumpAndSettle();
        expect(calls, 1);
        expect(tester.takeException(), isNull);
      },
    );
  }

  testWidgets(
    'Editorial progress preserves real values and native destination action',
    (tester) async {
      var opened = false;
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: FgImmersiveScaffold(
            bodyBuilder: (_) => FgReadingBody(
              child: ListView(
                children: [
                  FgProgressSection(
                    editorial: true,
                    immersive: true,
                    title: 'My progress',
                    stats: const [FgStatData(label: 'XP', value: '0')],
                    levelProgress: const FgProgressData(
                      label: 'White belt',
                      current: 0,
                      target: 1,
                      valueLabel: 'Next: Yellow',
                      message: 'XP is not mastery.',
                    ),
                    onProgressTap: () => opened = true,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.byType(FgSectionHeading), findsOneWidget);
      expect(find.text('0'), findsOneWidget);
      expect(find.text('XP is not mastery.'), findsOneWidget);
      expect(
        tester
            .widgetList<FgCard>(find.byType(FgCard))
            .every((c) => c.shape == FgCardShape.editorial),
        isTrue,
      );
      await tester.tap(find.text('White belt'));
      await tester.pumpAndSettle();
      expect(opened, isTrue);
      expect(tester.takeException(), isNull);
    },
  );

  testWidgets('Editorial radio groups preserve keyboard single selection', (
    tester,
  ) async {
    var selected = 'system';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: StatefulBuilder(
            builder: (context, setState) => FgReadingBody(
              child: FgRadioGroup<String>(
                editorial: true,
                semanticLabel: 'Appearance',
                selectedValue: selected,
                onChanged: (value) => setState(() => selected = value),
                items: const [
                  FgRadioGroupItem(label: 'System', value: 'system'),
                  FgRadioGroupItem(label: 'Light', value: 'light'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.tab);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(selected, 'light');
    expect(
      tester
          .widgetList<FgCard>(find.byType(FgCard))
          .every((c) => c.shape == FgCardShape.editorial),
      isTrue,
    );
    expect(tester.takeException(), isNull);
  });
}
