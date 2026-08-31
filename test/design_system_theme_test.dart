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
    final container = tester.widget<AnimatedContainer>(
      find.byType(AnimatedContainer),
    );
    final label = tester.widget<Text>(find.text('Dance'));

    expect((container.decoration as BoxDecoration).color, scheme.primary);
    expect(label.style?.color, scheme.onPrimary);
  });
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
