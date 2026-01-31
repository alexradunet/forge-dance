import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/molecules/learning/app_lesson_node.dart';
import '../../../../design_system/atoms/badges/app_badge.dart';
import '../../../../design_system/atoms/buttons/app_button.dart';
import '../../../../design_system/atoms/app_icon.dart';

class LearningPathPage extends StatelessWidget {
  final Function(String)? onNavigate;

  const LearningPathPage({super.key, this.onNavigate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: Stack(
        children: [
          _buildGridBackground(),
          CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: AppHeader(
                  title: "Hip Hop Foundations",
                  subtitle: "Module 1 • Path",
                  onBack:
                      onNavigate != null ? () => onNavigate!('explore') : null,
                ),
              ),
              SliverToBoxAdapter(child: _buildProgressIndicator()),
              SliverPadding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                sliver: SliverToBoxAdapter(
                  child: Stack(
                    alignment: Alignment.topCenter,
                    children: [
                      _buildPathLine(),
                      Column(
                        children: [
                          _buildNodeWrapper(
                            child: const AppLessonNode(
                              title: "History of Bounce",
                              type: AppLessonNodeType.theory,
                              status: AppLessonNodeStatus.completed,
                              duration: "15 min",
                            ),
                          ),
                          _buildActiveLessonWrapper(context),
                          _buildNodeWrapper(
                            child: const AppLessonNode(
                              title: "Timing Drill",
                              type: AppLessonNodeType.drill,
                              status: AppLessonNodeStatus.locked,
                              duration: "20 min",
                            ),
                          ),
                          _buildNodeWrapper(
                            child: const AppLessonNode(
                              title: "Flow Lab",
                              type: AppLessonNodeType.experiment,
                              status: AppLessonNodeStatus.locked,
                              duration: "30 min",
                            ),
                          ),
                          _buildBossChallenge(),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: SizedBox(height: 100)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGridBackground() {
    return Positioned.fill(
      child: CustomPaint(
        painter: GridPainter(color: Colors.white.withOpacity(0.02)),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      child: Row(
        children: List.generate(5, (index) {
          final isCompleted = index < 2;
          final isActive = index == 2;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 2),
              decoration: BoxDecoration(
                color: isCompleted || isActive
                    ? AppColors.forgeFire
                    : Colors.white.withOpacity(0.1),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildPathLine() {
    return Container(
      width: 2,
      height:
          800, // Approximate height, should ideally be dynamic or long enough
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            AppColors.forgeFire,
            AppColors.forgeFire.withOpacity(0.5),
            Colors.white.withOpacity(0.05),
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
    );
  }

  Widget _buildNodeWrapper({required Widget child}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: child,
    );
  }

  Widget _buildActiveLessonWrapper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 64),
      child: Column(
        children: [
          const AppLessonNode(
            title: "Groove Basics",
            type: AppLessonNodeType.movement,
            status: AppLessonNodeStatus.active,
            duration: "25 min",
          ),
          const SizedBox(height: 24),
          Container(
            width: 300,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surfaceDark,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 40,
                  offset: const Offset(0, 20),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const AppBadge(text: "Current Lesson"),
                    const SizedBox(width: 12),
                    Expanded(
                        child: Container(
                            height: 1, color: Colors.white.withOpacity(0.05))),
                  ],
                ),
                const SizedBox(height: 16),
                const Text(
                  "GROOVE BASICS",
                  style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Orbitron',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Master the essential hip-hop bounce and weight transfer techniques.",
                  style: AppTypography.bodySmall
                      .copyWith(color: AppColors.textMuted),
                ),
                const SizedBox(height: 24),
                AppButton(
                  text: "START PRACTICE",
                  variant: AppButtonVariant.primary,
                  icon: const AppIcon(icon: Icons.play_arrow),
                  width: double.infinity,
                  onPressed: () {
                    if (onNavigate != null) onNavigate!('training');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBossChallenge() {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.02),
                shape: BoxShape.circle,
              ),
            ),
            Transform.rotate(
              angle: 45 * 3.14159 / 180,
              child: Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: AppColors.bgDeep,
                  border: Border.all(
                    color: Colors.white.withOpacity(0.1),
                    width: 2,
                    style: BorderStyle.solid,
                  ),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -45 * 3.14159 / 180,
                    child: Icon(
                      Icons.emoji_events_outlined,
                      color: Colors.white.withOpacity(0.1),
                      size: 40,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Text(
          "THE FORGE FINALE",
          style: AppTypography.label.copyWith(
            color: Colors.white.withOpacity(0.2),
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          "BOSS SHOWCASE",
          style: TextStyle(
            color: Colors.white12,
            fontFamily: 'Orbitron',
            fontSize: 32,
            fontWeight: FontWeight.bold,
            letterSpacing: 2.0,
          ),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 48),
          child: Text(
            "Complete all previous lessons to unlock the final evaluation.",
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(color: Colors.white10),
          ),
        ),
      ],
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  GridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const step = 32.0;

    for (double i = 0; i < size.width; i += step) {
      canvas.drawLine(Offset(i, 0), Offset(i, size.height), paint);
    }
    for (double i = 0; i < size.height; i += step) {
      canvas.drawLine(Offset(0, i), Offset(size.width, i), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
