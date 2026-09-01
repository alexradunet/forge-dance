import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  final themes = <(String, ThemeData)>[
    ('light', AppThemes.light),
    ('dark', AppThemes.dark),
    ('high contrast light', AppThemes.highContrastLight),
    ('high contrast dark', AppThemes.highContrastDark),
  ];

  group('Forge theme contracts', () {
    for (final (name, theme) in themes) {
      test('$name exposes complete accessible semantic roles', () {
        final scheme = theme.colorScheme;
        final forge = theme.forgeColors;
        final pairs = <(String, Color, Color)>[
          ('primary', scheme.primary, scheme.onPrimary),
          (
            'primaryContainer',
            scheme.primaryContainer,
            scheme.onPrimaryContainer,
          ),
          ('secondary', scheme.secondary, scheme.onSecondary),
          (
            'secondaryContainer',
            scheme.secondaryContainer,
            scheme.onSecondaryContainer,
          ),
          ('tertiary', scheme.tertiary, scheme.onTertiary),
          (
            'tertiaryContainer',
            scheme.tertiaryContainer,
            scheme.onTertiaryContainer,
          ),
          ('error', scheme.error, scheme.onError),
          ('errorContainer', scheme.errorContainer, scheme.onErrorContainer),
          ('surface', scheme.surface, scheme.onSurface),
          (
            'surfaceContainerHighest',
            scheme.surfaceContainerHighest,
            scheme.onSurface,
          ),
          ('inverseSurface', scheme.inverseSurface, scheme.onInverseSurface),
          ('immersive', forge.immersiveBackground, forge.onImmersive),
          (
            'immersive muted',
            forge.immersiveBackground,
            forge.onImmersiveMuted,
          ),
          ('success', forge.success, forge.onSuccess),
          ('warning', forge.warning, forge.onWarning),
          ('reward', forge.reward, forge.onReward),
        ];

        for (final (role, background, foreground) in pairs) {
          expect(
            _contrastRatio(background, foreground),
            greaterThanOrEqualTo(4.5),
            reason: '$name $role must support normal-sized text',
          );
        }
      });

      test('$name uses deterministic Forge typography', () {
        expect(theme.useMaterial3, isTrue);
        expect(
          theme.textTheme.displayLarge?.fontFamily,
          AppTypography.displayFamily,
        );
        expect(
          theme.textTheme.bodyMedium?.fontFamily,
          AppTypography.bodyFamily,
        );
        expect(theme.forgeColors, isA<ForgeColors>());
        expect(theme.forgeEmphasis, isA<ForgeEmphasis>());
      });

      test('$name keeps interactive controls at least 48 logical pixels', () {
        final buttonStyle = theme.filledButtonTheme.style!;
        final iconButtonStyle = theme.iconButtonTheme.style!;

        expect(
          buttonStyle.minimumSize?.resolve({})?.height,
          greaterThanOrEqualTo(48),
        );
        expect(
          iconButtonStyle.minimumSize?.resolve({})?.height,
          greaterThanOrEqualTo(48),
        );
      });
    }

    test('high-contrast themes remove blur and shadow-only emphasis', () {
      for (final theme in [
        AppThemes.highContrastLight,
        AppThemes.highContrastDark,
      ]) {
        final emphasis = theme.forgeEmphasis;
        expect(emphasis.glassBlurSigma, 0);
        expect(emphasis.raised, isEmpty);
        expect(emphasis.floating, isEmpty);
        expect(emphasis.primaryAction, isEmpty);
        expect(emphasis.glassBorder, theme.colorScheme.outline);
      }
    });
  });

  testWidgets('selected ThemeData reaches rendered Material components', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FilledButton(onPressed: () {}, child: const Text('Dance')),
        ),
      ),
    );

    final context = tester.element(find.byType(FilledButton));
    expect(Theme.of(context).colorScheme, AppThemes.light.colorScheme);
    expect(Theme.of(context).forgeColors, AppThemes.light.forgeColors);
  });

  testWidgets('FgButton consumes the accessible primary color pair', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FgButton(text: 'Dance', onPressed: () {}),
        ),
      ),
    );

    final scheme = AppThemes.light.colorScheme;
    final button = tester.widget<FilledButton>(find.byType(FilledButton));
    final label = tester.widget<Text>(find.text('Dance'));

    expect(button.style?.backgroundColor?.resolve({}), scheme.primary);
    expect(label.style?.color, scheme.onPrimary);
  });
  testWidgets(
    'immersive primitives use the foreground paired with FgBackground',
    (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppThemes.light,
          home: Scaffold(
            body: FgBackground(
              child: Column(
                children: [
                  FgButton(
                    text: 'Ghost action',
                    variant: FgButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  const FgIcon(icon: Icons.notifications_none_rounded),
                  const FgLabel(text: 'Section'),
                  const FgEmpty(
                    icon: Icons.error_outline,
                    title: 'Unexpected error occurred',
                    description: 'Try again.',
                  ),
                  const FgProgressSection(
                    title: 'Continue training',
                    stats: [],
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      final forgeColors = AppThemes.light.forgeColors;
      expect(_textColor(tester, 'Ghost action'), forgeColors.onImmersiveMuted);
      expect(
        tester
            .widget<Icon>(find.byIcon(Icons.notifications_none_rounded))
            .color,
        forgeColors.onImmersive,
      );
      expect(_textColor(tester, 'SECTION'), forgeColors.onImmersiveMuted);
      expect(
        _textColor(tester, 'Unexpected error occurred'),
        forgeColors.onImmersive,
      );
      expect(_textColor(tester, 'Try again.'), forgeColors.onImmersiveMuted);
      expect(_textColor(tester, 'Continue training'), forgeColors.onImmersive);
    },
  );

  testWidgets('FgCard restores standard surface foreground roles', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: Scaffold(
          body: FgBackground(
            child: FgCard(
              child: Column(
                children: [
                  FgButton(
                    text: 'Card action',
                    variant: FgButtonVariant.ghost,
                    onPressed: () {},
                  ),
                  const FgIcon(icon: Icons.info_outline),
                  const FgLabel(text: 'Card label'),
                ],
              ),
            ),
          ),
        ),
      ),
    );

    final scheme = AppThemes.light.colorScheme;
    expect(_textColor(tester, 'Card action'), scheme.onSurfaceVariant);
    expect(
      tester.widget<Icon>(find.byIcon(Icons.info_outline)).color,
      scheme.onSurface,
    );
    expect(_textColor(tester, 'CARD LABEL'), scheme.onSurfaceVariant);
  });
}

Color? _textColor(WidgetTester tester, String text) {
  final widget = tester.widget<Text>(find.text(text));
  return widget.style?.color ?? widget.textSpan?.style?.color;
}

double _contrastRatio(Color first, Color second) {
  final firstLuminance = _relativeLuminance(first);
  final secondLuminance = _relativeLuminance(second);
  final lighter = math.max(firstLuminance, secondLuminance);
  final darker = math.min(firstLuminance, secondLuminance);
  return (lighter + 0.05) / (darker + 0.05);
}

double _relativeLuminance(Color color) {
  double linearize(double channel) {
    return channel <= 0.04045
        ? channel / 12.92
        : math.pow((channel + 0.055) / 1.055, 2.4).toDouble();
  }

  return 0.2126 * linearize(color.r) +
      0.7152 * linearize(color.g) +
      0.0722 * linearize(color.b);
}
