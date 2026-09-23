import 'dart:ui' show SemanticsFlag;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/constants/assets.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  test(
    'poster copy has AA contrast even over a completely white photograph',
    () {
      for (final theme in [
        AppThemes.light,
        AppThemes.dark,
        AppThemes.highContrastLight,
        AppThemes.highContrastDark,
      ]) {
        final colors = theme.forgeColors;
        final backing = Color.alphaBlend(
          colors.immersiveBackground.withValues(
            alpha: FgDanceHero.copyScrimOpacity,
          ),
          Colors.white,
        );
        for (final foreground in [
          colors.onImmersive,
          colors.onImmersiveMuted,
        ]) {
          final ratio =
              (foreground.computeLuminance() + 0.05) /
              (backing.computeLuminance() + 0.05);
          expect(ratio, greaterThanOrEqualTo(4.5));
        }
      }
    },
  );

  testWidgets('photo destination is one labelled keyboard action', (
    tester,
  ) async {
    final semantics = tester.ensureSemantics();
    var opened = 0;
    try {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: Scaffold(
            body: Align(
              alignment: Alignment.topLeft,
              child: SizedBox(
                width: 280,
                child: FgPhotoTile(
                  image: const AssetImage(Assets.danceFloorPreview),
                  label: 'Programmes',
                  title: 'Build a routine',
                  onTap: () => opened++,
                ),
              ),
            ),
          ),
        ),
      );
      final data = tester.getSemantics(find.byType(FgCard)).getSemanticsData();
      expect(data.hasFlag(SemanticsFlag.isButton), isTrue);
      expect(data.label, contains('Build a routine'));
      expect(find.byType(InkWell), findsOneWidget);
      await tester.sendKeyEvent(LogicalKeyboardKey.tab);
      await tester.pumpAndSettle();
      await tester.sendKeyEvent(LogicalKeyboardKey.enter);
      await tester.pumpAndSettle();
      expect(opened, 1);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('failed poster photo preserves copy and a usable action', (
    tester,
  ) async {
    final image = MemoryImage(Uint8List.fromList([0]));
    var opened = false;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: SingleChildScrollView(
            child: FgDanceHero(
              image: image,
              imageLabel: 'Preview photo',
              eyebrow: 'Your floor',
              title: 'Find your flow',
              subtitle: 'Go at your own pace.',
              action: FgButton(
                text: 'Practice',
                variant: FgButtonVariant.secondary,
                onPressed: () => opened = true,
              ),
            ),
          ),
        ),
      ),
    );
    await tester.runAsync(
      () => precacheImage(
        image,
        tester.element(find.byType(FgPhoto)),
        onError: (_, _) {},
      ),
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.music_note_outlined), findsOneWidget);
    expect(find.text('Find your flow'), findsOneWidget);
    expect(
      tester.widget<Text>(find.text('Practice')).style!.color,
      AppThemes.light.forgeColors.onImmersive,
    );
    await tester.ensureVisible(find.text('Practice'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Practice'));
    expect(opened, isTrue);
    expect(tester.takeException(), isNull);
  });

  for (final scale in [1.0, 2.0]) {
    testWidgets('photo tiles adapt without clipping at text scale $scale', (
      tester,
    ) async {
      await tester.binding.setSurfaceSize(const Size(390, 900));
      addTearDown(() => tester.binding.setSurfaceSize(null));
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.dark,
          home: Scaffold(
            body: MediaQuery(
              data: MediaQueryData(textScaler: TextScaler.linear(scale)),
              child: SingleChildScrollView(
                child: Padding(
                  padding: AppSpacing.allLG,
                  child: FgPhotoTileLayout(
                    children: [
                      FgPhotoTile(
                        image: const AssetImage(Assets.studioDancerPreview),
                        label: 'Learn',
                        title: 'Find your style',
                        onTap: () {},
                      ),
                      FgPhotoTile(
                        image: const AssetImage(Assets.danceFloorPreview),
                        label: 'Programmes',
                        title: 'Build a routine',
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
      await tester.pumpAndSettle();
      final first = tester.getRect(find.byType(FgPhotoTile).first);
      final second = tester.getRect(find.byType(FgPhotoTile).last);
      if (scale == 1) {
        expect(first.top, second.top);
        expect(first.right, lessThan(second.left));
      } else {
        expect(first.bottom, lessThan(second.top));
      }
      expect(tester.takeException(), isNull);
    });
  }
}
