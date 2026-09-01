import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/design_system/theme/app_themes.dart';
import 'package:forge_dance/localization/app_locales.dart';
import 'package:go_router/go_router.dart';

const _packageAssetRoot = 'packages/forge_dance';

Future<void> initializeForgePreview() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final inter = FontLoader('Inter')
    ..addFont(
      rootBundle.load(
        '$_packageAssetRoot/assets/google_fonts/Inter-Variable.ttf',
      ),
    );
  final bebasNeue = FontLoader('Bebas Neue')
    ..addFont(
      rootBundle.load(
        '$_packageAssetRoot/assets/google_fonts/BebasNeue-Regular.ttf',
      ),
    );
  await Future.wait([inter.load(), bebasNeue.load()]);
}

Widget buildForgePreview(BuildContext context, Widget child) {
  return ProviderScope(
    child: EasyLocalization(
      supportedLocales: AppLocales.supported,
      path: '$_packageAssetRoot/assets/translations',
      fallbackLocale: AppLocales.fallback,
      useOnlyLangCode: true,
      saveLocale: false,
      child: _ForgePreviewApp(child: child),
    ),
  );
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
