import 'package:accessibility_tools/accessibility_tools.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/design_system/design_system.dart';
import 'package:go_router/go_router.dart';
import 'package:widgetbook/widgetbook.dart';

import 'atom_stories.dart';
import 'foundation_stories.dart';
import 'molecule_stories.dart';
import 'organism_stories.dart';
import 'screen_stories.dart';
import 'template_stories.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('vi')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        child: const ForgeWidgetbook(),
      ),
    ),
  );
}

class ForgeWidgetbook extends StatelessWidget {
  const ForgeWidgetbook({super.key});

  @override
  Widget build(BuildContext context) {
    final themes = [
      WidgetbookTheme(name: 'Forge Light', data: AppThemes.light),
      WidgetbookTheme(name: 'Forge Dark', data: AppThemes.dark),
      WidgetbookTheme(
        name: 'Forge High Contrast Light',
        data: AppThemes.highContrastLight,
      ),
      WidgetbookTheme(
        name: 'Forge High Contrast Dark',
        data: AppThemes.highContrastDark,
      ),
    ];

    return Widgetbook.material(
      directories: [
        WidgetbookCategory(
          name: 'Foundations',
          children: buildFoundationStories(),
        ),
        WidgetbookCategory(name: 'Atoms', children: buildAtomStories()),
        WidgetbookCategory(name: 'Molecules', children: buildMoleculeStories()),
        WidgetbookCategory(name: 'Organisms', children: buildOrganismStories()),
        WidgetbookCategory(name: 'Templates', children: buildTemplateStories()),
        WidgetbookCategory(name: 'Screens', children: buildScreenStories()),
      ],
      addons: [
        MaterialThemeAddon(themes: themes, initialTheme: themes[1]),
        ViewportAddon(const [
          IosViewports.iPhoneSE,
          IosViewports.iPhone13,
          AndroidViewports.onePlus8Pro,
          AndroidViewports.samsungGalaxyA50,
          AndroidViewports.smallTablet,
          IosViewports.iPadAir4,
          MacosViewports.macbookPro,
        ]),
        TextScaleAddon(min: 1, max: 3.2, divisions: 11, initialScale: 1),
        _ReducedMotionAddon(),
        BuilderAddon(
          name: 'Accessibility audit',
          builder: (context, child) =>
              AccessibilityTools(checkFontOverflows: true, child: child),
        ),
      ],
      appBuilder: (context, child) => _ForgePreviewApp(child: child),
      lightTheme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.system,
      header: const _ForgeWidgetbookHeader(),
    );
  }
}

class _ForgePreviewApp extends StatefulWidget {
  const _ForgePreviewApp({required this.child});

  final Widget child;

  @override
  State<_ForgePreviewApp> createState() => _ForgePreviewAppState();
}

class _ForgePreviewAppState extends State<_ForgePreviewApp> {
  late final GoRouter _router = GoRouter(
    routes: [
      for (final path in ['/', '/login', '/register', '/onboarding', '/main'])
        GoRoute(
          path: path,
          pageBuilder: (context, state) =>
              NoTransitionPage(child: widget.child),
        ),
    ],
  );

  @override
  void didUpdateWidget(covariant _ForgePreviewApp oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) _router.refresh();
  }

  @override
  void dispose() {
    _router.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      theme: AppThemes.light,
      darkTheme: AppThemes.dark,
      themeMode: ThemeMode.system,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

class _ReducedMotionAddon extends WidgetbookAddon<bool> {
  _ReducedMotionAddon() : super(name: 'Reduced motion');

  @override
  List<Field> get fields => [
    BooleanField(name: 'enabled', initialValue: false),
  ];

  @override
  bool valueFromQueryGroup(Map<String, String> group) {
    return valueOf('enabled', group) ?? false;
  }

  @override
  Widget buildUseCase(BuildContext context, Widget child, bool setting) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(disableAnimations: setting),
      child: child,
    );
  }
}

class _ForgeWidgetbookHeader extends StatelessWidget {
  const _ForgeWidgetbookHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.allLG,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('FORGE.DANCE', style: AppTypography.h5),
          Text(
            'Design system workbench',
            style: AppTypography.caption.copyWith(color: AppColors.gray400),
          ),
        ],
      ),
    );
  }
}
