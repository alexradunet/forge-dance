import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../routing/routes.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../model/profile.dart';
import '../../ui/view_model/profile_view_model.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/avatars/fg_avatar.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../ui/widgets/level_grid.dart';
import '../../model/level_model.dart';
import '../pages/level_progression_page.dart'; // Added import

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage> {
  @override
  void initState() {
    super.initState();
  }

  void _openLevelProgression(BuildContext context, {int? levelId}) {
    // Find index of levelId or default to current user level
    // For now, defaulting to first 'current' level or 0
    final levels = DanceLevel.getAllLevels();
    int initialIndex = 0;

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

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: _buildMainContent(profile),
      ),
    );
  }

  Widget _buildMainContent(Profile? profile) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: 'PROFILE',
            subtitle: 'Pro Dancer • Lvl 42',
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
          child: _buildProfileInfo(profile),
        ),
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
            child: GestureDetector(
              onTap: () => _openLevelProgression(context),
              child: Row(
                children: [
                  Text(
                    'SKILL MASTERY',
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
            levels: DanceLevel.getAllLevels(),
            onLevelTap: (level) =>
                _openLevelProgression(context, levelId: level.id),
          ),
        ),
      ],
    );
  }

  Widget _buildProfileInfo(Profile? profile) {
    return Column(
      children: [
        const SizedBox(height: 24),
        FgAvatar(
          imageUrl: profile?.avatar,
          level: 42,
          size: 128,
          borderColor: AppColors.legendGold,
        ),
        const SizedBox(height: 20),
        Text(
          profile?.name ?? 'Alex "Pulse" Chen',
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Lvl 42 • Pro Dancer',
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
