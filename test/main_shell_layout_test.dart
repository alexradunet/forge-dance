import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/main/presentation/pages/main_screen.dart';
import 'package:forge_dance/routing/routes.dart';

void main() {
  testWidgets('navigation reserves space instead of covering page actions', (
    tester,
  ) async {
    const contentKey = Key('content');
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: const MainScreen(
          location: Routes.explore,
          child: SizedBox.expand(key: contentKey),
        ),
      ),
    );
    expect(
      tester.getRect(find.byKey(contentKey)).bottom,
      lessThanOrEqualTo(tester.getRect(find.byType(AppBottomNav)).top),
    );
    expect(tester.takeException(), isNull);
  });
}
