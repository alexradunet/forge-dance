import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:forge_dance/design_system/molecules/cards/fg_interactive_card.dart';

import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../stats/ui/view_model/user_stats_provider.dart';
import '../../model/level_model.dart';

/// Belt ladder viewer — statuses, progress, and XP requirements all derive
/// from the user's real stats.
class LevelProgressionPage extends ConsumerWidget {
  final int initialLevelIndex;
  final VoidCallback? onClose;

  const LevelProgressionPage({
    super.key,
    this.initialLevelIndex = 0,
    this.onClose,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final stats = ref.watch(userStatsProvider);

    return stats.when(
      loading: () => const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: Center(child: FgSpinner()),
      ),
      error: (_, __) => const Scaffold(
        backgroundColor: AppColors.bgDeep,
        body: CommonError(),
      ),
      data: (stats) => _LevelPager(
        levels: DanceLevel.buildAll(totalXp: stats.totalXp),
        initialIndex: initialLevelIndex,
        onClose: onClose,
      ),
    );
  }
}

class _LevelPager extends StatefulWidget {
  final List<DanceLevel> levels;
  final int initialIndex;
  final VoidCallback? onClose;

  const _LevelPager({
    required this.levels,
    required this.initialIndex,
    this.onClose,
  });

  @override
  State<_LevelPager> createState() => _LevelPagerState();
}

class _LevelPagerState extends State<_LevelPager> {
  late final PageController _pageController;
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.levels.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onStepClick(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return SwipeableCardScreenTemplate(
      title: LocaleKeys.skillMastery.tr().toUpperCase(),
      subtitle: LocaleKeys.levelProgression.tr().toUpperCase(),
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      progressSteps: widget.levels.length,
      currentStep: _currentIndex,
      customStepColors: widget.levels.map((l) => l.color).toList(),
      onStepClick: _onStepClick,
      children: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          HapticFeedback.selectionClick();
        },
        itemCount: widget.levels.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildLevelCard(widget.levels[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(DanceLevel level) {
    final bool isLocked = level.isLocked;

    return FgInteractiveCard(
      title: isLocked ? LocaleKeys.lockedLabel.tr().toUpperCase() : level.name,
      subtitle: level.status.name,
      backgroundImage:
          'https://images.unsplash.com/photo-1547153760-18fc86324498?q=80&w=1000&auto=format&fit=crop',
      level: 'LVL ${level.id}',
      style: isLocked ? '???' : 'MASTERY',
      difficulty: isLocked ? '???' : 'UNLOCKED',
      progress: level.progress,
      isFavorited: false,
      backTitle: isLocked ? 'LOCKED LEVEL' : 'REQUIREMENTS',
      backSubtitle: 'LEVEL ${level.id}',
      backContent: isLocked
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.lock_outline,
                      size: 64, color: AppColors.textMuted),
                  const SizedBox(height: 16),
                  Text(
                    LocaleKeys.reachXpRequirement
                        .tr(args: ['${level.xpThreshold}']),
                    textAlign: TextAlign.center,
                    style:
                        AppTypography.body.copyWith(color: AppColors.textMuted),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: level.requirements
                  .map((req) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              req.isMet
                                  ? Icons.check_circle
                                  : Icons.circle_outlined,
                              color: req.isMet
                                  ? AppColors.growthGreen
                                  : AppColors.textMuted,
                              size: 16,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                req.description,
                                style: AppTypography.bodySmall.copyWith(
                                  color: req.isMet
                                      ? Colors.white
                                      : AppColors.textMuted,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ))
                  .toList(),
            ),

      // Footer
      footer: isLocked
          ? null
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  level.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
                  style: AppTypography.label.copyWith(
                    color: level.isCompleted
                        ? AppColors.growthGreen
                        : AppColors.forgeFire,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
    );
  }
}
