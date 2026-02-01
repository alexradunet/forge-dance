import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:go_router/go_router.dart';

import '../../../generated/locale_keys.g.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import 'widgets/appearance_item.dart';

class AppearancesScreen extends ConsumerWidget {
  const AppearancesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: 'appearances'.tr(),
              onBack: () => context.pop(),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedSettings01,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: 'auto'.tr(),
                    value: ThemeMode.system,
                    isFirst: true,
                  ),
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedIdea,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: LocaleKeys.lightMode.tr(),
                    value: ThemeMode.light,
                  ),
                  AppearanceItem(
                    icon: HugeIcon(
                      icon: HugeIcons.strokeRoundedMoon02,
                      color: context.primaryTextColor,
                      size: 20,
                    ),
                    text: LocaleKeys.darkMode.tr(),
                    value: ThemeMode.dark,
                    isLast: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
