import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';
import '../../../method/repository/method_catalog.dart';
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
          return FgReadingBody(
            child: CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: AppHeader(
                    title: LocaleKeys.levelProgression.tr(),
                    onBack: onClose ?? () => Navigator.of(context).pop(),
                  ),
                ),
                SliverPadding(
                  padding: AppSpacing.allXXL,
                  sliver: SliverList.list(
                    children: [
                      FgSectionHeading(
                        title: LocaleKeys.skillMastery.tr(),
                        subtitle: LocaleKeys.compactSelfAssessed.tr(),
                      ),
                      FgDetails(
                        title: LocaleKeys.detailsAboutMethod.tr(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(LocaleKeys.forgeXpSeparate.tr()),
                            const SizedBox(height: AppSpacing.md),
                            Text(LocaleKeys.forgeCriteriaProvisional.tr()),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      for (final level in levels) ...[
                        FgCard(
                          immersive: true,
                          shape: FgCardShape.editorial,
                          isSelected: level.isCurrent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                LocaleKeys.beltNameLabel.tr(args: [level.name]),
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              if (!level.isLocked)
                                Text(
                                  level.id == 1
                                      ? LocaleKeys.compactMethodEntryBelt.tr()
                                      : LocaleKeys.methodEarnedBelt.tr(),
                                ),
                              FgDetails(
                                key: ValueKey('belt-${level.id}'),
                                initiallyExpanded:
                                    level.id - 1 == initialLevelIndex,
                                title: level.requirements.isEmpty
                                    ? LocaleKeys.forgeRequirements.tr()
                                    : LocaleKeys.compactBeltProgress.tr(
                                        args: [
                                          '${level.requirements.where((requirement) => requirement.isMet).length}',
                                          '${level.requirements.length}',
                                        ],
                                      ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(forgeBelts[level.id - 1].description),
                                    const SizedBox(height: AppSpacing.sm),
                                    Text(
                                      level.isLocked
                                          ? LocaleKeys.forgeRequirements.tr()
                                          : level.id == 1
                                          ? LocaleKeys.forgeEntryBelt.tr()
                                          : LocaleKeys.forgeEarnedBelt.tr(),
                                    ),
                                    const SizedBox(height: AppSpacing.md),
                                    for (final requirement
                                        in level.requirements)
                                      Padding(
                                        padding: const EdgeInsets.only(
                                          bottom: AppSpacing.sm,
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Icon(
                                              requirement.isMet
                                                  ? Icons.check_circle_outline
                                                  : Icons
                                                        .radio_button_unchecked,
                                            ),
                                            const SizedBox(
                                              width: AppSpacing.sm,
                                            ),
                                            Expanded(
                                              child: Text(
                                                requirement.description,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                  ],
                                ),
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
            ),
          );
        },
      ),
    );
  }
}
