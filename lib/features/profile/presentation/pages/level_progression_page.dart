import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../design_system/templates/swipeable_card_screen_template.dart';
import '../../../../design_system/organisms/cards/fg_interactive_card.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../model/level_model.dart';

class LevelProgressionPage extends StatefulWidget {
  final int initialLevelIndex;
  final VoidCallback? onClose;

  const LevelProgressionPage({
    super.key,
    this.initialLevelIndex = 0,
    this.onClose,
  });

  @override
  State<LevelProgressionPage> createState() => _LevelProgressionPageState();
}

class _LevelProgressionPageState extends State<LevelProgressionPage> {
  late final PageController _pageController;
  late int _currentIndex;
  final List<DanceLevel> _levels = DanceLevel.getAllLevels();

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialLevelIndex;
    _pageController = PageController(initialPage: widget.initialLevelIndex);
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
      title: 'SKILL MASTERY',
      subtitle: 'LEVEL PROGRESSION',
      onBack: widget.onClose ?? () => Navigator.of(context).pop(),
      progressSteps: _levels.length,
      currentStep: _currentIndex,
      customStepColors: _levels.map((l) => l.color).toList(),
      onStepClick: _onStepClick,
      children: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
          HapticFeedback.selectionClick();
        },
        itemCount: _levels.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: _buildLevelCard(_levels[index]),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLevelCard(DanceLevel level) {
    final bool isLocked = level.isLocked;

    return FgInteractiveCard(
      title: isLocked ? 'LOCKED' : level.name,
      subtitle: level.status.name,
      backgroundImage:
          'https://images.unsplash.com/photo-1547153760-18fc86324498?q=80&w=1000&auto=format&fit=crop',
      level: 'LVL ${level.id}',
      style: isLocked ? '???' : 'MASTERY',
      difficulty: isLocked ? '???' : 'UNLOCKED',
      progress: level.isCompleted ? 1.0 : (level.isCurrent ? 0.3 : 0.0),
      // Locked State Visuals
      isFavorited: false,

      // If locked, maybe show less info on back?
      // User said "for those locked show them as locked".
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
                    'Complete previous levels to unlock.',
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
