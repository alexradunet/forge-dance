import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../profile/ui/widgets/profile_stats.dart';
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
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: stats.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, __) => const CommonError(),
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
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  label: LocaleKeys.currentStreak.tr(),
                  value: LocaleKeys.daysValue
                      .tr(args: ['${stats.streakCount}']),
                  icon: Icons.local_fire_department,
                  iconColor: AppColors.forgeFire,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProfileStatCard(
                  label: LocaleKeys.totalXpLabel.tr(),
                  value: formatXp(stats.totalXp),
                  icon: Icons.bolt,
                  iconColor: AppColors.electricBlue,
                ),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: ProfileStatCard(
                  label: LocaleKeys.levelLabel.tr(args: ['${stats.level}']),
                  value: LocaleKeys.beltNameLabel.tr(args: [stats.beltName]),
                  icon: Icons.military_tech,
                  iconColor: AppColors.legendGold,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ProfileStatCard(
                  label: stats.nextLevelXp == null
                      ? LocaleKeys.maxLevelReached.tr()
                      : LocaleKeys.nextLevelXp
                          .tr(args: ['${stats.nextLevelXp}']),
                  value: stats.nextLevelXp == null
                      ? formatXp(stats.totalXp)
                      : LocaleKeys.xpValue.tr(
                          args: ['${stats.nextLevelXp! - stats.totalXp}'],
                        ),
                  icon: Icons.trending_up,
                  iconColor: AppColors.mysticPurple,
                ),
              ),
            ],
          ),
        ),
      ),
    ]);
  }
}
