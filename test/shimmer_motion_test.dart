import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  testWidgets('shimmer follows reduced motion and ticker visibility changes', (
    tester,
  ) async {
    Widget placeholder({required bool reduced, bool visible = true}) =>
        MaterialApp(
          theme: AppThemes.dark,
          home: MediaQuery(
            data: MediaQueryData(disableAnimations: reduced),
            child: TickerMode(
              enabled: visible,
              child: const Center(child: FgShimmer(width: 100, height: 100)),
            ),
          ),
        );

    await tester.pumpWidget(placeholder(reduced: true));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(placeholder(reduced: false));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.binding.transientCallbackCount, greaterThan(0));

    await tester.pumpWidget(placeholder(reduced: true));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(placeholder(reduced: false, visible: false));
    await tester.pumpAndSettle();
    expect(tester.binding.transientCallbackCount, 0);

    await tester.pumpWidget(placeholder(reduced: false));
    await tester.pump(const Duration(milliseconds: 200));
    expect(tester.binding.transientCallbackCount, greaterThan(0));
    await tester.pumpWidget(const SizedBox.shrink());
    expect(tester.binding.transientCallbackCount, 0);
    expect(tester.takeException(), isNull);
  });
}
