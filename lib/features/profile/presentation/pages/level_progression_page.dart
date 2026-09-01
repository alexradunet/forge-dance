import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
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
        body: Center(child: FgSpinner()),
      ),
      error: (_, _) => Scaffold(
        body: FgEmpty(
          icon: Icons.error_outline,
          title: LocaleKeys.unexpectedErrorOccurred.tr(),
          tone: FgEmptyTone.error,
        ),
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
    final motion = context.forgeMotion;
    _pageController.animateToPage(
      index,
      duration: motion.slow,
      curve: motion.enterCurve,
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
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: _buildLevelCard(widget.levels[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(DanceLevel level) {
    final isLocked = level.isLocked;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final forgeColors = theme.forgeColors;
    return FgInteractiveCard(
      title: isLocked ? LocaleKeys.lockedLabel.tr().toUpperCase() : level.name,
      flipSemanticLabel: LocaleKeys.flipCard.tr(),
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
                  FgIcon(
                    icon: Icons.lock_outline_rounded,
                    size: AppSizes.iconHuge,
                    color: scheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    LocaleKeys.reachXpRequirement
                        .tr(args: ['${level.xpThreshold}']),
                    textAlign: TextAlign.center,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: level.requirements
                  .map(
                    (req) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FgIcon(
                            icon: req.isMet
                                ? Icons.check_circle_rounded
                                : Icons.circle_outlined,
                            color: req.isMet
                                ? forgeColors.success
                                : scheme.onSurfaceVariant,
                            size: AppSizes.iconSm,
                          ),
                          const SizedBox(width: AppSpacing.sm),
                          Expanded(
                            child: Text(
                              req.description,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: req.isMet
                                    ? scheme.onSurface
                                    : scheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
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
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: level.isCompleted
                        ? forgeColors.success
                        : scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
    );
  }
}
