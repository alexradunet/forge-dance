import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';
import '../../../method/ui/method_view_model.dart';
import '../../model/level_model.dart';

/// Earned belts and transparent requirements, independent of participation XP.
class LevelProgressionPage extends ConsumerWidget {
  const LevelProgressionPage({
    super.key,
    this.initialLevelIndex = 0,
    this.onClose,
  });

  final int initialLevelIndex;
  final VoidCallback? onClose;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mastery = ref.watch(methodViewModelProvider);
    return FgImmersiveScaffold(
      bodyBuilder: (context) => mastery.when(
        loading: () => const Center(child: FgSpinner()),
        error: (_, _) => FgEmpty(
          icon: Icons.error_outline,
          title: LocaleKeys.unexpectedErrorOccurred.tr(),
          tone: FgEmptyTone.error,
        ),
        data: (progress) {
          final levels = DanceLevel.buildAll(progress: progress);
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppHeader(
                  title: LocaleKeys.levelProgression.tr(),
                  subtitle: LocaleKeys.forgeXpSeparate.tr(),
                  onBack: onClose ?? () => Navigator.of(context).pop(),
                ),
              ),
              SliverPadding(
                padding: AppSpacing.allXXL,
                sliver: SliverList.list(
                  children: [
                    Text(LocaleKeys.forgeCriteriaProvisional.tr()),
                    const SizedBox(height: AppSpacing.lg),
                    for (final level in levels) ...[
                      FgCard(
                        immersive: true,
                        isSelected: level.isCurrent,
                        child: ExpansionTile(
                          key: ValueKey(level.id),
                          initiallyExpanded: level.id - 1 == initialLevelIndex,
                          tilePadding: EdgeInsets.zero,
                          title: Text(
                            LocaleKeys.beltNameLabel.tr(args: [level.name]),
                          ),
                          subtitle: Text(
                            level.isLocked
                                ? LocaleKeys.forgeRequirements.tr()
                                : level.id == 1
                                ? LocaleKeys.forgeEntryBelt.tr()
                                : LocaleKeys.forgeEarnedBelt.tr(),
                          ),
                          children: [
                            for (final requirement in level.requirements)
                              ListTile(
                                contentPadding: EdgeInsets.zero,
                                leading: Icon(
                                  requirement.isMet
                                      ? Icons.check_circle_outline
                                      : Icons.radio_button_unchecked,
                                ),
                                title: Text(requirement.description),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.md),
                    ],
                    FgButton(
                      text: LocaleKeys.forgeAssessments.tr(),
                      expand: true,
                      onPressed: () {
                        Navigator.of(context).pop();
                        context.push(Routes.method);
                      },
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
