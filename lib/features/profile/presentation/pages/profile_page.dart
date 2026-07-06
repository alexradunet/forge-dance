import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../constants/constants.dart';
import '../../../../routing/routes.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../stats/model/user_stats.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/profile.dart';
import '../../ui/view_model/profile_view_model.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/avatars/fg_avatar.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
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

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => LevelProgressionPage(
        initialLevelIndex: initialIndex,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profile =
        ref.watch(profileViewModelProvider.select((it) => it.value?.profile));
    final stats = ref.watch(userStatsProvider).valueOrNull ?? const UserStats();

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: _buildMainContent(profile, stats),
      ),
    );
  }

  Widget _buildMainContent(Profile? profile, UserStats stats) {
    final levels = DanceLevel.buildAll(totalXp: stats.totalXp);
    final levelSubtitle = LocaleKeys.levelBeltSubtitle
        .tr(args: ['${stats.level}', stats.beltName]);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.profileTitle.tr().toUpperCase(),
            subtitle: levelSubtitle,
            rightSlot: IconButton(
              onPressed: () => context.push(Routes.settings),
              icon: const Icon(
                Icons.settings,
                color: AppColors.textMuted,
                size: 24,
              ),
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: _buildProfileInfo(profile, stats, levelSubtitle),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: GestureDetector(
              onTap: () => _openLevelProgression(context, levels),
              child: Row(
                children: [
                  Text(
                    LocaleKeys.skillMastery.tr().toUpperCase(),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                      color: AppColors.textMuted,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Divider(
                      color: Colors.white.withOpacity(0.1),
                      height: 1,
                    ),
                  ),
                  Icon(
                    Icons.chevron_right,
                    color: AppColors.textMuted,
                    size: 16,
                  ),
                ],
              ),
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
    return Column(
      children: [
        const SizedBox(height: 24),
        FgAvatar(
          imageUrl: profile?.avatar,
          level: stats.level,
          size: 128,
          borderColor: AppColors.legendGold,
        ),
        const SizedBox(height: 20),
        Text(
          profile?.name ?? Constants.defaultName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          levelSubtitle,
          style: TextStyle(
            fontSize: 12,
            fontFamily: 'JetBrains Mono',
            color: AppColors.textMuted,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
