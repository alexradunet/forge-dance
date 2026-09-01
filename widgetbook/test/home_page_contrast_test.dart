import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:forge_dance/features/home/presentation/pages/home_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgetbook_workspace/forge_preview_app.dart';
import 'package:widgetbook_workspace/preview_data/screen_preview_providers.dart';

Future<void> main() async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await initializeForgePreview();

  testWidgets('Home loaded headings use immersive foreground in light theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      Builder(
        builder: (context) => buildForgePreview(
          context,
          buildHomePreview(
            condition: PreviewLearnCondition.loaded,
            child: const HomePage(),
          ),
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 500));
    await tester.drag(find.byType(CustomScrollView), const Offset(0, -600));
    await tester.pump();

    final heading = tester.widget<Text>(find.text('CONTINUE TRAINING'));
    expect(heading.style?.color, AppThemes.light.forgeColors.onImmersive);
  });
}
