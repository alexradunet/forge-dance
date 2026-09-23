import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  for (final width in [320.0, 1040.0]) {
    for (final theme in [AppThemes.light, AppThemes.highContrastDark]) {
      testWidgets(
        'editorial primitives reflow at $width in ${theme.brightness}',
        (tester) async {
          await tester.binding.setSurfaceSize(Size(width, 900));
          addTearDown(() => tester.binding.setSurfaceSize(null));
          var pressed = false;
          await tester.pumpWidget(
            MaterialApp(
              theme: theme,
              home: MediaQuery(
                data: const MediaQueryData(
                  textScaler: TextScaler.linear(2),
                  disableAnimations: true,
                ),
                child: Scaffold(
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        FgDanceHero(
                          image: const AssetImage(
                            'assets/images/cypher-dancer.webp',
                          ),
                          eyebrow: 'YOUR FLOOR. YOUR PACE.',
                          title: 'MAKE YOUR\nNEXT MOVE.',
                          subtitle: 'Find your groove at a comfortable pace.',
                          action: FgButton(
                            text: 'Practice',
                            onPressed: () => pressed = true,
                            expand: true,
                          ),
                        ),
                        const FgRoundPanel(
                          label: 'ROUND 01 / 04',
                          active: true,
                          child: FgSectionHeading(
                            title: 'Find the pocket',
                            subtitle: 'Keep safety information visible.',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
          await tester.pump();
          final action = find.widgetWithText(FgButton, 'Practice');
          await tester.ensureVisible(action);
          await tester.tap(action);
          expect(pressed, isTrue);
          expect(tester.takeException(), isNull);
          final button = tester.widget<FilledButton>(find.byType(FilledButton));
          expect(
            button.style!.minimumSize!.resolve({})!.height,
            greaterThanOrEqualTo(48),
          );
        },
      );
    }
  }

  testWidgets('long actions wrap instead of losing their consequences', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: SizedBox(
            width: 240,
            child: FgButton(
              text: 'Choose demonstration / evidence (pauses practice)',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    final label = tester.widget<Text>(
      find.text('Choose demonstration / evidence (pauses practice)'),
    );
    expect(label.maxLines, isNull);
    expect(label.overflow, isNot(TextOverflow.ellipsis));
    expect(tester.takeException(), isNull);
  });

  testWidgets('stage gives custom-rendered content a semantic description', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();

    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: const Scaffold(
          body: FgMovementStage(
            semanticLabel: 'Paused mannequin, front view',
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
    expect(
      find.bySemanticsLabel('Paused mannequin, front view'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
    semantics.dispose();
  });

  test(
    'adopted screens do not reintroduce raw palette or pixel text sizes',
    () {
      // This guard supplements, never replaces, rendered screen contracts.
      for (final path in [
        'lib/features/home/presentation/pages/home_page.dart',
        'lib/features/practice/ui/practice_page.dart',
        'lib/features/practice_player/ui/practice_player_page.dart',
        'lib/features/movement_teacher/prototype/ui/motion_lab_page.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('AppColors.')), reason: path);
        expect(
          RegExp(r'Color\(0x|fontSize\s*:').hasMatch(source),
          isFalse,
          reason: path,
        );
      }
      for (final path in [
        'lib/design_system/molecules/media/fg_dance_hero.dart',
        'lib/design_system/molecules/media/fg_movement_stage.dart',
        'lib/design_system/molecules/typography/fg_section_heading.dart',
        'lib/design_system/molecules/cards/fg_round_panel.dart',
      ]) {
        final source = File(path).readAsStringSync();
        expect(source, isNot(contains('/features/')), reason: path);
        expect(source, isNot(contains('riverpod')), reason: path);
      }
    },
  );
}
