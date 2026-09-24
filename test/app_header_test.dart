import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    final displayFont = FontLoader(AppTypography.displayFamily)
      ..addFont(rootBundle.load('assets/google_fonts/BebasNeue-Regular.ttf'));
    final bodyFont = FontLoader(AppTypography.bodyFamily)
      ..addFont(rootBundle.load('assets/google_fonts/Inter-Variable.ttf'));
    await Future.wait([displayFont.load(), bodyFont.load()]);
  });
  testWidgets('page header aligns in full-width and reading-width layouts', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: FgImmersiveScaffold(
          title: 'Full width',
          bodyBuilder: (_) => const FgReadingBody(
            child: AppHeader(title: 'Reading width', onBack: _back),
          ),
        ),
      ),
    );
    expect(
      tester.getTopLeft(find.text('FULL WIDTH')).dx,
      tester.getTopLeft(find.text('READING WIDTH')).dx,
    );
    expect(tester.takeException(), isNull);
  });

  testWidgets('long page title wraps without overlapping back and action', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(320, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    var backs = 0;
    var actions = 0;
    const title = 'Movement profile and practice history';
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.light,
        home: MediaQuery(
          data: const MediaQueryData(
            textScaler: TextScaler.linear(2),
            padding: EdgeInsets.only(top: 32),
          ),
          child: Scaffold(
            body: AppHeader(
              title: title,
              subtitle: 'Your local progress',
              onBack: () => backs++,
              rightSlot: FgIconButton(
                icon: Icons.settings,
                semanticLabel: 'Settings',
                onPressed: () => actions++,
              ),
            ),
          ),
        ),
      ),
    );
    final titleFinder = find.text(title.toUpperCase());
    final titleRect = tester.getRect(titleFinder);
    expect(titleRect.top, 32 + AppSpacing.lg);
    expect(
      titleRect.left,
      greaterThanOrEqualTo(tester.getRect(find.byType(BackButton)).right),
    );
    expect(
      titleRect.right,
      lessThanOrEqualTo(tester.getRect(find.byType(FgIconButton)).left),
    );
    expect(tester.widget<Text>(titleFinder).maxLines, isNull);
    await tester.tap(find.byType(BackButton));
    await tester.tap(find.byType(FgIconButton));
    expect(backs, 1);
    expect(actions, 1);
    expect(tester.takeException(), isNull);
  });

  testWidgets('compact player header keeps its full-width compact contract', (
    tester,
  ) async {
    await tester.binding.setSurfaceSize(const Size(1200, 900));
    addTearDown(() => tester.binding.setSurfaceSize(null));
    await tester.pumpWidget(
      MaterialApp(
        theme: AppThemes.dark,
        home: Scaffold(
          body: AppHeader(
            title: 'Active round',
            compact: true,
            rightSlot: FgIconButton(
              icon: Icons.close,
              semanticLabel: 'End round',
              onPressed: () {},
            ),
          ),
        ),
      ),
    );
    final title = find.text('ACTIVE ROUND');
    expect(tester.getTopLeft(title).dx, AppSpacing.xxl);
    expect(
      tester.widget<Text>(title).style!.fontSize,
      AppTypography.h4.fontSize,
    );
    expect(tester.widget<Text>(title).maxLines, 2);
    expect(
      tester.getRect(find.byType(FgIconButton)).right,
      1200 - AppSpacing.xxl,
    );
    expect(tester.takeException(), isNull);
  });
}

void _back() {}
