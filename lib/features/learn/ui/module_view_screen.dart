import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/organisms/lessons/lesson_path_timeline.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';

/// Module View Screen matching dashboard_4 mockup
class ModuleViewScreen extends StatelessWidget {
  final String moduleTitle;
  final String moduleSubtitle;
  final String progress; // e.g., "4/12"
  final VoidCallback? onBack;

  const ModuleViewScreen({
    super.key,
    this.moduleTitle = 'BREAKING 101',
    this.moduleSubtitle = 'Fundamentals',
    this.progress = '4/12',
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Stack(
          children: [
            CustomScrollView(
              slivers: [
                // Header
                SliverToBoxAdapter(
                  child: _buildHeader(context),
                ),
                // Progress bar
                SliverToBoxAdapter(
                  child: _buildProgressBar(),
                ),
                // Lesson path
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: LessonPathTimeline(
                      nodes: _getMockLessons(),
                    ),
                  ),
                ),
                // Boss challenge (trophy)
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
                    child: _buildBossChallenge(),
                  ),
                ),
              ],
            ),
            // Start button
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: _buildStartButton(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return AppHeader(
      title: moduleTitle,
      subtitle: moduleSubtitle,
      onBack: onBack ?? () => Navigator.of(context).pop(),
      rightSlot: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.check_circle,
              size: 14,
              color: AppColors.forgeFire,
            ),
            const SizedBox(width: 4),
            Text(
              progress,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    // Parse progress string (e.g., "4/12")
    final parts = progress.split('/');
    final current = int.tryParse(parts[0]) ?? 0;
    final total = int.tryParse(parts.length > 1 ? parts[1] : '12') ?? 12;
    final progressValue = current / total;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MODULE PROGRESS',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textMuted,
                  letterSpacing: 1,
                ),
              ),
              Text(
                '${(progressValue * 100).round()}%',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: AppColors.forgeFire,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Container(
            height: 6,
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(3),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progressValue,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.forgeFire, AppColors.legendGold],
                  ),
                  borderRadius: BorderRadius.circular(3),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.forgeFire.withOpacity(0.5),
                      blurRadius: 8,
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildBossChallenge() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.legendGold.withOpacity(0.2),
            AppColors.legendGold.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.legendGold.withOpacity(0.3)),
        boxShadow: [
          BoxShadow(
            color: AppColors.legendGold.withOpacity(0.1),
            blurRadius: 20,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppColors.legendGold.withOpacity(0.3),
                  AppColors.legendGold.withOpacity(0.1),
                ],
              ),
              border: Border.all(
                color: AppColors.legendGold.withOpacity(0.5),
                width: 2,
              ),
            ),
            child: Center(
              child: Icon(
                Icons.emoji_events,
                size: 32,
                color: AppColors.legendGold,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.lock,
                      size: 12,
                      color: AppColors.textMuted,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'BOSS CHALLENGE',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.legendGold,
                        letterSpacing: 1,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  'Complete all lessons to unlock',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.transparent,
            AppColors.bgDeep,
          ],
        ),
      ),
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.forgeFire, const Color(0xFFE03E00)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: AppColors.forgeFire.withOpacity(0.4),
              blurRadius: 20,
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () {},
            borderRadius: BorderRadius.circular(16),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_arrow, color: Colors.white, size: 28),
                  const SizedBox(width: 8),
                  Text(
                    'CONTINUE',
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 20,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<LessonNode> _getMockLessons() {
    return const [
      LessonNode(
        title: 'Introduction to Breaking',
        type: LessonNodeType.theory,
        state: LessonNodeState.completed,
        duration: '3 min',
      ),
      LessonNode(
        title: 'Top Rock Basics',
        type: LessonNodeType.drill,
        state: LessonNodeState.completed,
        duration: '5 min',
      ),
      LessonNode(
        title: 'Indian Step Pattern',
        type: LessonNodeType.movement,
        state: LessonNodeState.completed,
        duration: '8 min',
      ),
      LessonNode(
        title: 'Footwork Foundation',
        type: LessonNodeType.theory,
        state: LessonNodeState.completed,
        duration: '4 min',
      ),
      LessonNode(
        title: '6-Step Breakdown',
        type: LessonNodeType.drill,
        state: LessonNodeState.current,
        duration: '10 min',
      ),
      LessonNode(
        title: '6-Step Flow Practice',
        type: LessonNodeType.movement,
        state: LessonNodeState.locked,
        duration: '12 min',
      ),
      LessonNode(
        title: 'Create Your Combo',
        type: LessonNodeType.experiment,
        state: LessonNodeState.locked,
        duration: '15 min',
      ),
    ];
  }
}
