import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../model/stats_rules.dart';
import '../../model/user_stats.dart';
import '../../ui/view_model/user_stats_provider.dart';

/// Performance metrics: real streak and XP derived from lesson progress and
/// the persisted profile stats.
class StatsPage extends ConsumerWidget {
  const StatsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return Scaffold(
      body: FgBackground(
        child: stats.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
            tone: FgEmptyTone.error,
          ),
          data: (stats) => _buildMainContent(context, stats),
        ),
      ),
    );
  }

  Widget _buildMainContent(BuildContext context, UserStats stats) {
    return CustomScrollView(slivers: [
      SliverToBoxAdapter(
        child: AppHeader(
          title: LocaleKeys.myProgress.tr().toUpperCase(),
          subtitle: LocaleKeys.statsSubtitle.tr(),
          onBack: () => Navigator.of(context).pop(),
        ),
      ),
      SliverPadding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        sliver: SliverToBoxAdapter(
          child: FgProgressSection(
            title: LocaleKeys.statsSubtitle.tr(),
            stats: [
              FgStatData(
                label: LocaleKeys.currentStreak.tr(),
                value: LocaleKeys.daysValue.tr(args: ['${stats.streakCount}']),
                icon: Icons.local_fire_department_rounded,
                tone: FgStatTone.primary,
              ),
              FgStatData(
                label: LocaleKeys.totalXpLabel.tr(),
                value: formatXp(stats.totalXp),
                icon: Icons.bolt_rounded,
                tone: FgStatTone.secondary,
              ),
              FgStatData(
                label: LocaleKeys.levelLabel.tr(args: ['${stats.level}']),
                value: LocaleKeys.beltNameLabel.tr(args: [stats.beltName]),
                icon: Icons.military_tech_rounded,
                tone: FgStatTone.reward,
              ),
              FgStatData(
                label: stats.nextLevelXp == null
                    ? LocaleKeys.maxLevelReached.tr()
                    : LocaleKeys.nextLevelXp.tr(
                        args: ['${stats.nextLevelXp}'],
                      ),
                value: stats.nextLevelXp == null
                    ? formatXp(stats.totalXp)
                    : LocaleKeys.xpValue.tr(
                        args: ['${stats.nextLevelXp! - stats.totalXp}'],
                      ),
                icon: Icons.trending_up_rounded,
                tone: FgStatTone.success,
              ),
            ],
            levelProgress: FgProgressData(
              label: LocaleKeys.beltNameLabel.tr(args: [stats.beltName]),
              current: stats.totalXp.toDouble(),
              target:
                  stats.nextLevelXp?.toDouble() ?? stats.totalXp.toDouble(),
              valueLabel: LocaleKeys.xpValue.tr(args: ['${stats.totalXp}']),
              message: stats.nextLevelXp == null
                  ? LocaleKeys.maxLevelReached.tr()
                  : LocaleKeys.nextLevelXp.tr(
                      args: ['${stats.nextLevelXp}'],
                    ),
            ),
          ),
        ),
      ),
    ]);
  }
}
