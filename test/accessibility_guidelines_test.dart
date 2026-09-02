import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  for (final entry in <String, ThemeData>{
    'light': AppThemes.light,
    'dark': AppThemes.dark,
  }.entries) {
    testWidgets(
      'action primitives meet accessibility guidelines in ${entry.key}',
      (tester) async {
        final semantics = tester.ensureSemantics();

        await tester.pumpWidget(
          MaterialApp(
            theme: entry.value,
            home: MediaQuery(
              data: const MediaQueryData(textScaler: TextScaler.linear(2)),
              child: Scaffold(
                body: Center(
                  child: Wrap(
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.lg,
                    crossAxisAlignment: WrapCrossAlignment.center,
                    children: [
                      FgButton(text: 'Continue', onPressed: () {}),
                      FgButton(
                        text: 'Delete',
                        variant: FgButtonVariant.destructive,
                        onPressed: () {},
                      ),
                      FgIconButton(
                        icon: Icons.play_arrow_rounded,
                        semanticLabel: 'Play lesson',
                        variant: FgIconButtonVariant.primary,
                        onPressed: () {},
                      ),
                      FgFilterChip(
                        label: 'Strength',
                        isSelected: true,
                        onSelected: (_) {},
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );

        await expectLater(tester, meetsGuideline(androidTapTargetGuideline));
        await expectLater(tester, meetsGuideline(iOSTapTargetGuideline));
        await expectLater(tester, meetsGuideline(labeledTapTargetGuideline));
        await expectLater(tester, meetsGuideline(textContrastGuideline));

        semantics.dispose();
      },
    );
  }
}
