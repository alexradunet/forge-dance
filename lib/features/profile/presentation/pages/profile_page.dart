import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../routing/routes.dart';
import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../stats/model/user_stats.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/profile.dart';
import '../../ui/view_model/profile_view_model.dart';
import '../../ui/widgets/level_grid.dart';
import '../../model/level_model.dart';
import '../pages/level_progression_page.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  void _openLevelProgression(
    BuildContext context,
    List<DanceLevel> levels, {
    int? levelId,
  }) {
    int initialIndex;
    if (levelId != null) {
      initialIndex = levels.indexWhere((l) => l.id == levelId);
    } else {
      initialIndex = levels.indexWhere((l) => l.isCurrent);
    }
    if (initialIndex == -1) initialIndex = 0;

    ForgeBottomSheet.showPage<void>(
      context: context,
      child: LevelProgressionPage(initialLevelIndex: initialIndex),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(
      profileViewModelProvider.select((it) => it.value?.profile),
    );
    final stats = ref.watch(userStatsProvider).value ?? const UserStats();

    return Scaffold(
      body: FgBackground(child: _buildMainContent(profile, stats)),
    );
  }

  Widget _buildMainContent(Profile? profile, UserStats stats) {
    final levels = DanceLevel.buildAll(totalXp: stats.totalXp);
    final levelSubtitle = LocaleKeys.levelBeltSubtitle.tr(
      args: ['${stats.level}', stats.beltName],
    );

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.profileTitle.tr().toUpperCase(),
            subtitle: levelSubtitle,
            rightSlot: FgIconButton(
              icon: Icons.settings_rounded,
              semanticLabel: LocaleKeys.settings.tr(),
              onPressed: () => context.push(Routes.settings),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildProfileInfo(profile, stats, levelSubtitle),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.xxl,
              AppSpacing.sm,
            ),
            child: FgButton(
              text: LocaleKeys.skillMastery.tr().toUpperCase(),
              icon: const Icon(Icons.chevron_right_rounded),
              variant: FgButtonVariant.ghost,
              expand: true,
              onPressed: () => _openLevelProgression(context, levels),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: LevelGrid(
            levels: levels,
            onLevelTap: (level) =>
                _openLevelProgression(context, levels, levelId: level.id),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(
    Profile? profile,
    UserStats stats,
    String levelSubtitle,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        const SizedBox(height: AppSpacing.xxl),
        FgAvatar.large(
          imageUrl: profile?.avatar,
          initials: profile?.name,
          level: stats.level,
          tone: FgAvatarTone.reward,
          semanticLabel: profile?.name ?? Constants.defaultName,
        ),
        const SizedBox(height: AppSpacing.xl),
        Text(
          profile?.name ?? Constants.defaultName,
          style: theme.textTheme.titleLarge?.copyWith(
            color: theme.forgeColors.onImmersive,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          levelSubtitle,
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.forgeColors.onImmersiveMuted,
          ),
        ),
        const SizedBox(height: AppSpacing.xxl),
      ],
    );
  }
}
