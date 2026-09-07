import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets('immersive search stays dark in light theme and clears text', (
    tester,
  ) async {
    final controller = TextEditingController(text: 'Hip hop');
    addTearDown(controller.dispose);
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FgBackground(
            child: Padding(
              padding: AppSpacing.screen,
              child: FgInput.search(
                controller: controller,
                placeholder: 'Search programs',
                onClear: controller.clear,
                clearSemanticsLabel: 'Clear search',
              ),
            ),
          ),
        ),
      ),
    );
    final field = find.byType(TextField);
    expect(
      tester.widget<TextField>(field).style?.color,
      AppThemes.light.forgeColors.onImmersive,
    );
    expect(
      Theme.of(tester.element(field)).inputDecorationTheme.fillColor,
      AppThemes.light.forgeColors.immersiveSurface,
    );
    await tester.tap(find.byTooltip('Clear search'));
    await tester.pump();
    expect(controller.text, isEmpty);
    expect(tester.takeException(), isNull);
  });

  testWidgets('large-text headers keep title separate from action slots', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var wentBack = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(2)),
            child: AppHeader(
              title: 'Your training',
              subtitle: 'Keep moving at your own pace',
              onBack: () => wentBack = true,
              rightSlot: const SizedBox(
                key: Key('settings'),
                width: 48,
                height: 48,
                child: Icon(Icons.settings),
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(
      tester.getRect(find.text('YOUR TRAINING')).right,
      lessThan(tester.getRect(find.byKey(const Key('settings'))).left),
    );
    await tester.tap(find.byType(BackButton));
    expect(wentBack, isTrue);
  });

  testWidgets('progress cards share row height despite different labels', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: const Scaffold(
          body: Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 400,
              child: FgProgressSection(
                immersive: true,
                title: 'Progress',
                stats: [
                  FgStatData(
                    label: 'Your current consecutive training day streak',
                    value: 'Day 3',
                  ),
                  FgStatData(label: 'White belt', value: 'Level 1'),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    final cards = find.byType(FgCard);
    expect(
      tester.getSize(cards.at(0)).height,
      tester.getSize(cards.at(1)).height,
    );
    expect(tester.takeException(), isNull);
  });
}
