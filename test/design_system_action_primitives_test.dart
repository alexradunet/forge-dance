import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  group('action primitive contracts', () {
    testWidgets('every size keeps a minimum 48px interactive target', (
      tester,
    ) async {
      for (final size in FgButtonSize.values) {
        await _pump(
          tester,
          FgButton(text: size.name, size: size, onPressed: () {}),
        );

        expect(
          tester.getSize(find.byType(FilledButton)).height,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
          reason: 'FgButtonSize.${size.name}',
        );
      }

      for (final size in FgIconButtonSize.values) {
        await _pump(
          tester,
          FgIconButton(
            icon: Icons.play_arrow_rounded,
            semanticLabel: 'Play ${size.name}',
            size: size,
            onPressed: () {},
          ),
        );

        final targetSize = tester.getSize(find.byType(IconButton));
        expect(
          targetSize.shortestSide,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
          reason: 'FgIconButtonSize.${size.name}',
        );
      }

      await _pump(
        tester,
        FgFilterChip(label: 'Strength', isSelected: false, onSelected: (_) {}),
      );

      expect(
        tester.getSize(find.byType(FilterChip)).height,
        greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
      );
    });

    testWidgets('keyboard activation uses the public callbacks', (
      tester,
    ) async {
      var buttonActivations = 0;
      await _pump(
        tester,
        FgButton(
          text: 'Continue',
          autofocus: true,
          onPressed: () => buttonActivations++,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(buttonActivations, 1);

      var iconActivations = 0;
      await _pump(
        tester,
        FgIconButton(
          icon: Icons.favorite_outline_rounded,
          semanticLabel: 'Favorite',
          autofocus: true,
          onPressed: () => iconActivations++,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(iconActivations, 1);

      bool? chipSelection;
      await _pump(
        tester,
        FgFilterChip(
          label: 'Strength',
          isSelected: false,
          autofocus: true,
          onSelected: (value) => chipSelection = value,
        ),
      );
      await tester.sendKeyEvent(LogicalKeyboardKey.space);
      expect(chipSelection, isTrue);
    });

    testWidgets('assistive tap actions use the public callbacks', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final semanticsOwner = tester.binding.pipelineOwner.semanticsOwner!;

      var buttonActivations = 0;
      await _pump(
        tester,
        FgButton(text: 'Continue', onPressed: () => buttonActivations++),
      );
      semanticsOwner.performAction(
        tester.getSemantics(find.bySemanticsLabel('Continue')).id,
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(buttonActivations, 1);

      var iconActivations = 0;
      await _pump(
        tester,
        FgIconButton(
          icon: Icons.favorite_outline_rounded,
          semanticLabel: 'Favorite',
          onPressed: () => iconActivations++,
        ),
      );
      semanticsOwner.performAction(
        tester.getSemantics(find.bySemanticsLabel('Favorite')).id,
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(iconActivations, 1);

      bool? chipSelection;
      await _pump(
        tester,
        FgFilterChip(
          label: 'Strength',
          isSelected: false,
          onSelected: (value) => chipSelection = value,
        ),
      );
      semanticsOwner.performAction(
        tester.getSemantics(find.bySemanticsLabel('Strength')).id,
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(chipSelection, isTrue);

      semantics.dispose();
    });

    testWidgets('disabled selected chips expose both states', (tester) async {
      final semantics = tester.ensureSemantics();

      await _pump(
        tester,
        const FgFilterChip(label: 'Locked', isSelected: true, isEnabled: false),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Locked')),
        matchesSemantics(
          label: 'Locked',
          isButton: true,
          hasSelectedState: true,
          isSelected: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );

      semantics.dispose();
    });

    testWidgets('icon actions expose label, selected state, and tap action', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await _pump(
        tester,
        FgIconButton(
          icon: Icons.favorite_rounded,
          semanticLabel: 'Favorite',
          isSelected: true,
          onPressed: () {},
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Favorite')),
        matchesSemantics(
          label: 'Favorite',
          isButton: true,
          isSelected: true,
          hasSelectedState: true,
          hasEnabledState: true,
          isEnabled: true,
          hasTapAction: true,
        ),
      );
      semantics.dispose();
    });

    testWidgets('disabled and loading buttons remain semantically distinct', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await _pump(tester, const FgButton(text: 'Continue'));
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Continue')),
        matchesSemantics(
          label: 'Continue',
          isButton: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );

      await _pump(
        tester,
        FgButton(text: 'Saving', isLoading: true, onPressed: () {}),
      );
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(
        tester.getSemantics(find.bySemanticsLabel('Saving')),
        matchesSemantics(
          label: 'Saving',
          isButton: true,
          isLiveRegion: true,
          hasEnabledState: true,
          isEnabled: false,
        ),
      );
      semantics.dispose();
    });

    testWidgets('reduced motion removes custom action animations', (
      tester,
    ) async {
      await _pump(
        tester,
        FgButton(text: 'Continue', onPressed: () {}),
        disableAnimations: true,
      );

      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      expect(button.style?.animationDuration, Duration.zero);

      await _pump(
        tester,
        FgIconButton(
          icon: Icons.play_arrow_rounded,
          semanticLabel: 'Play',
          onPressed: () {},
        ),
        disableAnimations: true,
      );

      final visual = tester.widget<AnimatedContainer>(
        find.byType(AnimatedContainer),
      );
      expect(visual.duration, Duration.zero);
    });

    testWidgets('destructive buttons consume the error color pair', (
      tester,
    ) async {
      await _pump(
        tester,
        FgButton(
          text: 'Delete',
          variant: FgButtonVariant.destructive,
          onPressed: () {},
        ),
      );

      final scheme = AppThemes.light.colorScheme;
      final button = tester.widget<FilledButton>(find.byType(FilledButton));
      final label = tester.widget<Text>(find.text('Delete'));

      expect(button.style?.backgroundColor?.resolve({}), scheme.error);
      expect(label.style?.color, scheme.onError);
    });
  });
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  bool disableAnimations = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.light,
      home: MediaQuery(
        data: MediaQueryData(disableAnimations: disableAnimations),
        child: Scaffold(body: Center(child: child)),
      ),
    ),
  );
}
