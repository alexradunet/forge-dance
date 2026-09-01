import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgetbook/test.dart';
import 'package:widgetbook_workspace/forge_preview_app.dart';
import 'package:widgetbook_workspace/widgetbook.config.dart';

/// Runs one component, or one story, per test isolate.
///
/// Widgetbook 4.0.0-beta.13 drops semantics after the first component or story
/// in a suite. Isolating pilot captures preserves deterministic snapshots
/// until the upstream runner is fixed.
Future<void> testPilotComponent(
  String componentName, {
  String? storyName,
}) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  SharedPreferences.setMockInitialValues({});
  await initializeForgePreview();
  await testWidgetbook(
    cloudPilotConfigFor(componentName, storyName: storyName),
  );
}
