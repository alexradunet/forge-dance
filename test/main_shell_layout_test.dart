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

  testWidgets('all navigation destinations remain reachable at large text', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(390, 844));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var selected = 0;
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: MediaQuery(
          data: const MediaQueryData(textScaler: TextScaler.linear(2)),
          child: Scaffold(
            body: const SizedBox.expand(),
            bottomNavigationBar: AppBottomNav(
              currentIndex: selected,
              onTabChange: (index) => selected = index,
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    // Without a localization host, EasyLocalization renders the keys.
    for (final label in [
      'navLearn',
      'navHome',
      'navPractice',
      'profileTitle',
    ]) {
      expect(find.text(label).hitTestable(), findsOneWidget);
    }
    await tester.tap(find.text('profileTitle'));
    expect(selected, 4);
  });
}
