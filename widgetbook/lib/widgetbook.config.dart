import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:flutter/material.dart';
import 'package:forge_dance/design_system/theme/app_themes.dart';
import 'package:widgetbook/widgetbook.dart';

import 'components.g.dart';
import 'forge_preview_app.dart';
import 'reduced_motion_addon.dart';

final config = _buildConfig(components);

Config cloudPilotConfigFor(String componentName, {String? storyName}) {
  final component = components.singleWhere(
    (component) => component.name == componentName,
  );
  if (storyName != null) {
    component.stories.retainWhere((story) => story.name == storyName);
    if (component.stories.isEmpty) {
      throw StateError('Unknown story $componentName/$storyName');
    }
  }

  return _buildConfig([component]);
}

Config _buildConfig(List<Component> catalogue) => Config(
  components: catalogue,
  appBuilder: buildForgePreview,
  lightTheme: AppThemes.light,
  darkTheme: AppThemes.dark,
  header: const Padding(
    padding: EdgeInsets.all(16),
    child: Text(
      'FORGE.DANCE',
      style: TextStyle(fontWeight: FontWeight.w800, letterSpacing: 1.5),
    ),
  ),
  home: const _WidgetbookHome(),
  addons: [
    ViewportAddon([
      Viewports.none,
      IosViewports.iPhoneSE,
      IosViewports.iPhone13,
      IosViewports.iPadAir4,
      AndroidViewports.samsungGalaxyA50,
      AndroidViewports.smallTablet,
    ]),
    MaterialThemeAddon({
      'Light': AppThemes.light,
      'Dark': AppThemes.dark,
      'High Contrast Light': AppThemes.highContrastLight,
      'High Contrast Dark': AppThemes.highContrastDark,
    }),
    TextScaleAddon(),
    ReducedMotionAddon(),
    AlignmentAddon(),
    GridAddon(4),
    ZoomAddon(),
    SemanticsAddon(),
    BuilderAddon(
      name: 'Accessibility Checks',
      builder: (context, child) => AccessibilityTools(child: child),
    ),
  ],
  scenarioConfig: ScenarioConfig(
    definitions: [
      ScenarioDefinition(
        name: 'Mobile Default',
        strategy: ScenarioStrategy.perScenario,
        modes: [
          MaterialThemeMode('Light', AppThemes.light),
          ViewportMode(IosViewports.iPhone13),
          TextScaleMode(1),
          ReducedMotionMode(false),
        ],
      ),
      ScenarioDefinition(
        name: 'Accessibility Stress',
        strategy: ScenarioStrategy.perScenario,
        modes: [
          MaterialThemeMode('High Contrast Dark', AppThemes.highContrastDark),
          ViewportMode(IosViewports.iPhoneSE),
          TextScaleMode(2),
          ReducedMotionMode(true),
        ],
      ),
    ],
  ),
  accessibilityConfig: AccessibilityConfig(
    guidelines: WidgetbookGuidelines.recommended,
  ),
);

class _WidgetbookHome extends StatelessWidget {
  const _WidgetbookHome();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text(
            'Select a Forge component or screen from the catalogue.',
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
