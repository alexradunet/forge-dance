import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  group('surface primitive contracts', () {
    testWidgets(
      'interactive cards expose state and support keyboard activation',
      (tester) async {
        final semantics = tester.ensureSemantics();
        var activations = 0;

        await _pump(
          tester,
          FgCard(
            semanticLabel: 'Foundation lesson',
            isSelected: true,
            autofocus: true,
            onTap: () => activations++,
            child: const ExcludeSemantics(child: Text('Foundation lesson')),
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Foundation lesson')),
          matchesSemantics(
            label: 'Foundation lesson',
            isButton: true,
            hasSelectedState: true,
            isSelected: true,
            hasEnabledState: true,
            isEnabled: true,
            isFocusable: true,
            hasFocusAction: true,
            hasTapAction: true,
          ),
        );

        await tester.sendKeyEvent(LogicalKeyboardKey.enter);
        expect(activations, 1);
        semantics.dispose();
      },
    );

    testWidgets('locked content cards show availability without progress', (
      tester,
    ) async {
      await _pump(
        tester,
        const FgContentCard(
          title: 'Time & Weight',
          tags: ['Timing'],
          footerLabel: 'Requires Bases & Breath',
          progress: 0,
          isLocked: true,
        ),
      );

      expect(find.text('LOCKED'), findsOneWidget);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text('Requires Bases & Breath'), findsOneWidget);
      expect(find.byType(FgProgressBar), findsNothing);
    });

    testWidgets(
      'typed menu announces its action and returns the selected value',
      (tester) async {
        final semantics = tester.ensureSemantics();
        int? selected;

        await _pump(
          tester,
          FgMenuButton<int>(
            icon: Icons.grid_view_rounded,
            semanticLabel: 'Choose grid columns',
            items: const [
              FgMenuItem(value: 2, label: '2 columns', isSelected: true),
              FgMenuItem(value: 3, label: '3 columns'),
            ],
            onSelected: (value) => selected = value,
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Choose grid columns')),
          matchesSemantics(
            label: 'Choose grid columns',
            isButton: true,
            hasEnabledState: true,
            isEnabled: true,
            hasTapAction: true,
            isFocusable: true,
            hasFocusAction: true,
            hasExpandedState: true,
            isExpanded: false,
          ),
        );

        await tester.tap(find.bySemanticsLabel('Choose grid columns'));
        await tester.pumpAndSettle();
        await tester.tap(
          find.widgetWithText(CheckedPopupMenuItem<int>, '3 columns'),
        );
        await tester.pumpAndSettle();
        expect(selected, 3);
        semantics.dispose();
      },
    );

    testWidgets(
      'progress and avatar expose deterministic read-only semantics',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await _pump(
          tester,
          const Column(
            children: [
              FgProgressBar(value: 0.42, semanticLabel: 'Lesson progress'),
              FgAvatar.small(initials: 'FD', semanticLabel: 'Forge dancer'),
            ],
          ),
        );

        expect(
          tester.getSemantics(find.bySemanticsLabel('Lesson progress')),
          matchesSemantics(
            label: 'Lesson progress',
            value: '42%',
            isReadOnly: true,
          ),
        );
        expect(
          tester.getSemantics(find.bySemanticsLabel('Forge dancer')),
          matchesSemantics(label: 'Forge dancer', isImage: true),
        );
        semantics.dispose();
      },
    );

    testWidgets('alert dialog actions invoke callbacks and dismiss the route', (
      tester,
    ) async {
      var confirmed = false;

      await _pump(
        tester,
        Builder(
          builder: (context) => FgButton(
            text: 'Open alert',
            onPressed: () => ForgeAlertDialog.show(
              context: context,
              title: 'Leave session?',
              message: 'Progress is saved.',
              primaryActionLabel: 'Leave',
              secondaryActionLabel: 'Stay',
              onPrimaryAction: () => confirmed = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open alert'));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsOneWidget);

      await tester.tap(find.text('Leave'));
      await tester.pumpAndSettle();
      expect(confirmed, isTrue);
      expect(find.byType(AlertDialog), findsNothing);
    });
  });
}

Future<void> _pump(WidgetTester tester, Widget child) {
  return tester.pumpWidget(
    MaterialApp(
      theme: AppThemes.light,
      home: Scaffold(body: Center(child: child)),
    ),
  );
}
