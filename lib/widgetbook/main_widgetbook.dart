import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:widgetbook/widgetbook.dart';

import '../features/common/ui/widgets/primary_button.dart';
import '../features/home/ui/home_screen.dart';
import '../theme/app_colors.dart';
import '../theme/app_theme.dart';

/// Entry point for running the design system Widgetbook.
///
/// Run with:
/// `flutter run -t lib/widgetbook/main_widgetbook.dart`
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

/// Root Widgetbook app configured around the Forge design system.
class ForgeWidgetbook extends StatelessWidget {
  const ForgeWidgetbook({super.key});

  ThemeData _darkTheme() {
    final base = ThemeData.dark();
    return base.copyWith(
      scaffoldBackgroundColor: AppColors.gray950,
      colorScheme: base.colorScheme.copyWith(
        primary: AppColors.forgeFire,
        secondary: AppColors.electricBlue,
      ),
      textTheme: base.textTheme.copyWith(
        displayLarge: AppTheme.h1,
        displayMedium: AppTheme.h2,
        titleLarge: AppTheme.h5,
        bodyLarge: AppTheme.bodyLarge,
        bodyMedium: AppTheme.body,
        bodySmall: AppTheme.bodySmall,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Widgetbook.material(
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: 'Dark',
              data: _darkTheme(),
            ),
          ],
        ),
        DeviceFrameAddon(devices: Devices.all),
        TextScaleAddon(scales: [1.0, 1.2, 1.5]),
        LocalizationAddon(
          locales: const [Locale('en'), Locale('vi')],
          localizationsDelegates: const [],
        ),
        AlignmentAddon(),
      ],
      directories: [
        // ──────────────── ATOMS ────────────────
        WidgetbookFolder(
          name: 'Design System',
          children: [
            WidgetbookFolder(
              name: 'Atoms',
              children: [
                WidgetbookComponent(
                  name: 'Buttons / PrimaryButton',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: (context) => Center(
                        child: SizedBox(
                          width: 240,
                          child: PrimaryButton(
                            text: 'Primary',
                            onPressed: () {},
                          ),
                        ),
                      ),
                    ),
                    WidgetbookUseCase(
                      name: 'Disabled',
                      builder: (context) => Center(
                        child: SizedBox(
                          width: 240,
                          child: PrimaryButton(
                            text: 'Disabled',
                            onPressed: () {},
                            isEnable: false,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ──────────────── MOLECULES & ORGANISMS ────────────────
            WidgetbookFolder(
              name: 'Organisms',
              children: [
                WidgetbookComponent(
                  name: 'Home / FeaturedWorkoutCard',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: (context) => Scaffold(
                        backgroundColor: AppColors.gray950,
                        body: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(24),
                            child: SizedBox(
                              height: 400,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: FeaturedWorkoutCard(),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // ──────────────── PAGES ────────────────
            WidgetbookFolder(
              name: 'Pages',
              children: [
                WidgetbookComponent(
                  name: 'HomeScreen',
                  useCases: [
                    WidgetbookUseCase(
                      name: 'Default',
                      builder: (context) => const HomeScreen(),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

