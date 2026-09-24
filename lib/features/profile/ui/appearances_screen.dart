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
      body: SafeArea(
        child: FgReadingBody(
          child: ListView(
            padding: AppSpacing.allXXL,
            children: [
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: FgIconButton(
                  icon: Icons.arrow_back,
                  semanticLabel: MaterialLocalizations.of(context)
                      .backButtonTooltip,
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(height: AppSpacing.lg),
              FgSectionHeading(
                eyebrow: LocaleKeys.settings.tr(),
                title: LocaleKeys.appearances.tr(),
                subtitle: LocaleKeys.personalAppearanceIntro.tr(),
              ),
              const SizedBox(height: AppSpacing.xxxl),
              FgRadioGroup<ThemeMode>(
                editorial: true,
                semanticLabel: LocaleKeys.appearances.tr(),
                selectedValue: selectedMode,
                onChanged: (mode) =>
                    ref.read(appThemeModeProvider.notifier).updateMode(mode),
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
            ],
          ),
        ),
      ),
    );
  }
}
