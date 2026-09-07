import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/design_system/molecules/cards/fg_program_card.dart';

void main() {
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
