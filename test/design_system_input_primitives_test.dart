import 'dart:ui' show SemanticsAction, SemanticsValidationResult, Tristate;

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  group('input primitive contracts', () {
    test('themes own focused, error, and minimum input geometry', () {
      for (final theme in [
        AppThemes.light,
        AppThemes.dark,
        AppThemes.highContrastLight,
        AppThemes.highContrastDark,
      ]) {
        final inputTheme = theme.inputDecorationTheme;
        final focusedBorder = inputTheme.focusedBorder! as OutlineInputBorder;
        final errorBorder = inputTheme.errorBorder! as OutlineInputBorder;

        expect(focusedBorder.borderSide.color, theme.forgeColors.focusRing);
        expect(errorBorder.borderSide.color, theme.colorScheme.error);
        expect(
          inputTheme.constraints?.minHeight,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
        );
        expect(
          inputTheme.suffixIconConstraints?.minHeight,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
        );
      }
    });

    testWidgets('required labels expose required semantics', (tester) async {
      final semantics = tester.ensureSemantics();

      await _pumpInput(tester, const FgLabel(text: 'Email', isRequired: true));

      expect(
        tester.getSemantics(find.bySemanticsLabel('Email')),
        matchesSemantics(
          label: 'Email',
          hasRequiredState: true,
          isRequired: true,
        ),
      );

      semantics.dispose();
    });

    testWidgets('field semantics associate required and validation state', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await _pumpInput(
        tester,
        const FgInput(
          label: 'Email',
          isRequired: true,
          errorText: 'Enter a valid email address',
        ),
      );

      final node = tester.getSemantics(find.byType(EditableText));
      expect(node.label, contains('Email'));
      expect(
        node.getSemanticsData().flagsCollection.isRequired,
        Tristate.isTrue,
      );
      expect(node.validationResult, SemanticsValidationResult.invalid);

      semantics.dispose();
    });

    testWidgets('fields submit text and advance caller-owned focus', (
      tester,
    ) async {
      final firstFocus = FocusNode();
      final secondFocus = FocusNode();
      addTearDown(firstFocus.dispose);
      addTearDown(secondFocus.dispose);
      var submittedValue = '';

      await _pumpInput(
        tester,
        Column(
          children: [
            FgInput(
              label: 'Email',
              focusNode: firstFocus,
              autofocus: true,
              textInputAction: TextInputAction.next,
              onSubmitted: (value) {
                submittedValue = value;
                secondFocus.requestFocus();
              },
            ),
            FgInput(label: 'Name', focusNode: secondFocus),
          ],
        ),
      );

      await tester.enterText(find.byType(EditableText).first, 'a@b.co');
      await tester.testTextInput.receiveAction(TextInputAction.next);
      await tester.pump();

      expect(submittedValue, 'a@b.co');
      expect(secondFocus.hasFocus, isTrue);
    });

    testWidgets('autofill and keyboard metadata reach the editable field', (
      tester,
    ) async {
      await _pumpInput(
        tester,
        const FgInput(
          label: 'Email',
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: [AutofillHints.username, AutofillHints.email],
        ),
      );

      final editable = tester.widget<EditableText>(find.byType(EditableText));
      expect(editable.keyboardType, TextInputType.emailAddress);
      expect(editable.textInputAction, TextInputAction.done);
      expect(
        editable.autofillHints,
        containsAll([AutofillHints.username, AutofillHints.email]),
      );
    });

    testWidgets('password visibility has labeled assistive toggle behavior', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();

      await _pumpInput(
        tester,
        FgInput.password(
          label: 'Password',
          showPasswordSemanticsLabel: 'Show password',
          hidePasswordSemanticsLabel: 'Hide password',
        ),
      );

      expect(
        tester.getSemantics(find.bySemanticsLabel('Show password')),
        matchesSemantics(
          label: 'Show password',
          isButton: true,
          hasToggledState: true,
          isToggled: false,
          hasTapAction: true,
        ),
      );
      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isTrue,
      );

      final showNode = tester.getSemantics(
        find.bySemanticsLabel('Show password'),
      );
      tester.binding.pipelineOwner.semanticsOwner!.performAction(
        showNode.id,
        SemanticsAction.tap,
      );
      await tester.pumpAndSettle();

      expect(
        tester.widget<EditableText>(find.byType(EditableText)).obscureText,
        isFalse,
      );
      expect(find.bySemanticsLabel('Hide password'), findsOneWidget);

      semantics.dispose();
    });

    testWidgets('search actions are labeled, sized, and invoke callbacks', (
      tester,
    ) async {
      final semantics = tester.ensureSemantics();
      final controller = TextEditingController(text: 'House');
      addTearDown(controller.dispose);
      var clearCalls = 0;
      var filterCalls = 0;

      await _pumpInput(
        tester,
        FgInput.search(
          controller: controller,
          onClear: () => clearCalls++,
          clearSemanticsLabel: 'Clear search',
          showFilter: true,
          onFilterPressed: () => filterCalls++,
          filterSemanticsLabel: 'Filter search',
        ),
      );

      final iconButtons = find.byType(IconButton);
      for (var index = 0; index < iconButtons.evaluate().length; index++) {
        expect(
          tester.getSize(iconButtons.at(index)).shortestSide,
          greaterThanOrEqualTo(AppSizes.comfortableTouchTarget),
        );
      }

      expect(
        tester.getSemantics(find.bySemanticsLabel('Clear search')),
        matchesSemantics(
          label: 'Clear search',
          isButton: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.bySemanticsLabel('Clear search'));
      await tester.pumpAndSettle();
      expect(controller.text, isEmpty);
      expect(clearCalls, 1);

      expect(
        tester.getSemantics(find.bySemanticsLabel('Filter search')),
        matchesSemantics(
          label: 'Filter search',
          isButton: true,
          hasTapAction: true,
        ),
      );
      await tester.tap(find.bySemanticsLabel('Filter search'));
      await tester.pumpAndSettle();
      expect(filterCalls, 1);

      semantics.dispose();
    });

    testWidgets(
      'disabled, read-only, error, and loading states stay distinct',
      (tester) async {
        await _pumpInput(
          tester,
          const FgInput(label: 'Disabled', isEnabled: false),
        );
        var field = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(field.enabled, isFalse);

        await _pumpInput(
          tester,
          const FgInput(label: 'Read only', readOnly: true),
        );
        field = tester.widget<TextFormField>(find.byType(TextFormField));
        final editable = tester.widget<EditableText>(find.byType(EditableText));
        expect(field.enabled, isTrue);
        expect(editable.readOnly, isTrue);

        await _pumpInput(
          tester,
          const FgInput(
            label: 'Email',
            helperText: 'Helper is replaced by error',
            errorText: 'Enter a valid email address',
          ),
        );
        expect(find.text('Enter a valid email address'), findsOneWidget);
        expect(find.text('Helper is replaced by error'), findsNothing);

        final semantics = tester.ensureSemantics();
        await _pumpInput(
          tester,
          const FgInput(
            label: 'Email',
            isLoading: true,
            loadingSemanticsLabel: 'Loading email',
          ),
        );
        field = tester.widget<TextFormField>(find.byType(TextFormField));
        expect(field.enabled, isFalse);
        expect(find.byType(CircularProgressIndicator), findsOneWidget);
        expect(
          tester.getSemantics(find.bySemanticsLabel('Loading email')),
          matchesSemantics(label: 'Loading email', isLiveRegion: true),
        );
        semantics.dispose();
      },
    );

    testWidgets('large text and long validation copy remain layout-safe', (
      tester,
    ) async {
      await _pumpInput(
        tester,
        FgInput.multiline(
          label: 'Preferred training notes and notification details',
          helperText:
              'Include the movement, tempo, and the specific blocker you are '
              'experiencing.',
          errorText:
              'This description needs enough detail for your coach to '
              'understand the problem.',
        ),
        textScale: 2,
      );

      expect(tester.takeException(), isNull);
      expect(
        tester.getSize(find.byType(TextFormField)).height,
        greaterThan(AppSizes.comfortableTouchTarget),
      );
      expect(find.textContaining('enough detail'), findsOneWidget);
    });

    testWidgets('reduced motion removes suffix transitions', (tester) async {
      await _pumpInput(
        tester,
        FgInput.password(
          label: 'Password',
          showPasswordSemanticsLabel: 'Show password',
          hidePasswordSemanticsLabel: 'Hide password',
        ),
        disableAnimations: true,
      );

      expect(
        tester.widget<AnimatedSwitcher>(find.byType(AnimatedSwitcher)).duration,
        Duration.zero,
      );
    });
  });
}

Future<void> _pumpInput(
  WidgetTester tester,
  Widget child, {
  double textScale = 1,
  bool disableAnimations = false,
}) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.light,
      home: MediaQuery(
        data: MediaQueryData(
          textScaler: TextScaler.linear(textScale),
          disableAnimations: disableAnimations,
        ),
        child: Scaffold(
          body: SingleChildScrollView(padding: AppSpacing.screen, child: child),
        ),
      ),
    ),
  );
}
