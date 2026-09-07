import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets('immersive progress uses readable surfaces and opens details', (
    tester,
  ) async {
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: SizedBox(
              width: 280,
              child: FgProgressSection(
                immersive: true,
                title: 'Progress',
                stats: const [
                  FgStatData(label: 'Current streak', value: 'Day 3'),
                  FgStatData(label: 'Level 1', value: '60 XP'),
                ],
                levelProgress: const FgProgressData(
                  label: 'White belt',
                  current: 60,
                  target: 240,
                  valueLabel: 'Next level: 240 XP',
                ),
                onProgressTap: () => opened = true,
              ),
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Day 3'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Day 3')).style?.color,
      AppThemes.light.forgeColors.onImmersive,
    );
    final first = tester.getTopLeft(find.text('Day 3'));
    final second = tester.getTopLeft(find.text('60 XP'));
    expect(second.dy, greaterThan(first.dy));
    await tester.tap(find.text('White belt'));
    expect(opened, isTrue);
  });
}
