import 'dart:ui' show SemanticsAction;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  group('selection primitive contracts', () {
    testWidgets('toggle exposes state and assistive activation', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      bool? changed;

      await _pump(
        tester,
        FgToggle(
          value: false,
          semanticLabel: 'Practice reminders',
          onChanged: (value) => changed = value,
        ),
      );

      final node = tester.getSemantics(
        find.bySemanticsLabel('Practice reminders'),
      );
      expect(
        node,
        matchesSemantics(
          label: 'Practice reminders',
          hasEnabledState: true,
          isEnabled: true,
          hasToggledState: true,
          isToggled: false,
          hasTapAction: true,
        ),
      );

      tester.binding.pipelineOwner.semanticsOwner!.performAction(
        node.id,
        SemanticsAction.tap,
      );
      await tester.pump();
      expect(changed, isTrue);

      semantics.dispose();
    });

    testWidgets('checkbox exposes checked, mixed, and disabled states', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      var taps = 0;

      await _pump(
        tester,
        Column(
          children: [
            FgCheckboxItem(
              state: FgCheckboxState.checked,
              semanticLabel: 'Musicality',
              onTap: () => taps++,
            ),
            const FgCheckboxItem(
              state: FgCheckboxState.indeterminate,
              semanticLabel: 'Conditioning',
            ),
            const FgCheckboxItem(
              state: FgCheckboxState.unchecked,
              semanticLabel: 'Freestyle',
              isEnabled: false,
            ),
          ],
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Musicality')),
        matchesSemantics(
          label: 'Musicality',
          hasEnabledState: true,
          isEnabled: true,
          hasCheckedState: true,
          isChecked: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Conditioning')),
        matchesSemantics(
          label: 'Conditioning',
          hasEnabledState: true,
          hasCheckedState: true,
          isCheckStateMixed: true,
        ),
      );
      expect(
        tester.getSemantics(find.bySemanticsLabel('Freestyle')),
        matchesSemantics(
          label: 'Freestyle',
          hasEnabledState: true,
          isEnabled: false,
          hasCheckedState: true,
          isChecked: false,
        ),
      );

      await tester.tap(find.bySemanticsLabel('Musicality'));
      expect(taps, 1);

      semantics.dispose();
    });

    testWidgets('radio group reports a single selection and changes value', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      String? changed;

      await _pump(
        tester,
        FgRadioGroup<String>(
          semanticLabel: 'Experience level',
          selectedValue: 'beginner',
          items: const [
            FgRadioGroupItem(label: 'Beginner', value: 'beginner'),
            FgRadioGroupItem(label: 'Advanced', value: 'advanced'),
          ],
          onChanged: (value) => changed = value,
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Beginner')),
        matchesSemantics(
          label: 'Beginner',
          hasEnabledState: true,
          isEnabled: true,
          hasSelectedState: true,
          isSelected: true,
          hasCheckedState: true,
          isChecked: true,
          hasTapAction: true,
          hasFocusAction: true,
          isFocusable: true,
          isInMutuallyExclusiveGroup: true,
        ),
      );

      await tester.tap(find.bySemanticsLabel('Advanced'));
      expect(changed, 'advanced');

      semantics.dispose();
    });

    testWidgets('slider exposes native increase behavior and formatted value', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      double? changed;

      await _pump(
        tester,
        FgSlider(
          value: 100,
          min: 60,
          max: 180,
          semanticLabel: 'Practice tempo',
          semanticFormatterCallback: (value) => '${value.round()} BPM',
          onChanged: (value) => changed = value,
        ),
      );

      final node = tester.getSemantics(find.bySemanticsLabel('Practice tempo'));
      expect(node.value, '100 BPM');
      expect(
        node.getSemanticsData().hasAction(SemanticsAction.increase),
        isTrue,
      );

      tester.binding.pipelineOwner.semanticsOwner!.performAction(
        node.id,
        SemanticsAction.increase,
      );
      await tester.pump();
      expect(changed, greaterThan(100));

      semantics.dispose();
    });

    testWidgets('stepper actions keep 48px targets and honor bounds', (
      tester,
    ) async {
      int? changed;

      await _pump(
        tester,
        FgStepper(
          value: 1,
          min: 1,
          max: 3,
          decrementSemanticsLabel: 'Decrease rounds',
          incrementSemanticsLabel: 'Increase rounds',
          onChanged: (value) => changed = value,
        ),
      );

      for (final target in tester.widgetList<IconButton>(
        find.byType(IconButton),
      )) {
        expect(
          target.constraints?.minHeight,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
        );
      }

      await tester.tap(find.bySemanticsLabel('Decrease rounds'));
      expect(changed, isNull);
      await tester.tap(find.bySemanticsLabel('Increase rounds'));
      expect(changed, 2);
    });

    testWidgets('groups remain layout-safe at two-times text scale', (
      tester,
    ) async {
      await _pump(
        tester,
        const SizedBox(
          width: 320,
          child: FgCheckboxGroup(
            semanticLabel: 'Long goals',
            items: [
              FgCheckboxGroupItem(
                label: 'Improve musicality through detailed rhythm practice',
                description: 'A long supporting explanation that must wrap.',
                value: true,
              ),
            ],
          ),
        ),
        textScaler: const TextScaler.linear(2),
      );

      expect(tester.takeException(), isNull);
    });
  });
}

Future<void> _pump(
  WidgetTester tester,
  Widget child, {
  TextScaler textScaler = TextScaler.noScaling,
}) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.dark,
      home: MediaQuery(
        data: MediaQueryData(textScaler: textScaler),
        child: Scaffold(
          body: Center(
            child: SingleChildScrollView(
              padding: AppSpacing.screen,
              child: child,
            ),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}
