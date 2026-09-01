import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../common/ui/providers/app_theme_mode_provider.dart';

class AppearancesScreen extends ConsumerWidget {
  const AppearancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedMode =
        ref.watch(appThemeModeProvider).value ?? ThemeMode.system;
    final iconColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Scaffold(
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.appearances.tr(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: AppSpacing.allLG,
                child: FgRadioGroup<ThemeMode>(
                  semanticLabel: LocaleKeys.appearances.tr(),
                  selectedValue: selectedMode,
                  onChanged: (mode) => ref
                      .read(appThemeModeProvider.notifier)
                      .updateMode(mode),
                  items: [
                    FgRadioGroupItem(
                      label: LocaleKeys.auto.tr(),
                      value: ThemeMode.system,
                      leading: FgIcon(
                        icon: Icons.settings_suggest_rounded,
                        color: iconColor,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    FgRadioGroupItem(
                      label: LocaleKeys.lightMode.tr(),
                      value: ThemeMode.light,
                      leading: FgIcon(
                        icon: Icons.light_mode_rounded,
                        color: iconColor,
                        size: AppSizes.iconMd,
                      ),
                    ),
                    FgRadioGroupItem(
                      label: LocaleKeys.darkMode.tr(),
                      value: ThemeMode.dark,
                      leading: FgIcon(
                        icon: Icons.dark_mode_rounded,
                        color: iconColor,
                        size: AppSizes.iconMd,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
