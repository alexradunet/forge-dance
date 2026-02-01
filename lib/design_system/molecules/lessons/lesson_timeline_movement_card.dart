import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../organisms/lessons/lesson_node_models.dart';
import '../../atoms/progress/fg_progress_bar.dart';
import '../../atoms/badges/fg_badge.dart';
import '../../atoms/buttons/fg_icon_button.dart';

class LessonTimelineMovementCard extends StatelessWidget {
  final LessonNode node;
  final Function(String)? onNavigate;

  const LessonTimelineMovementCard({
    super.key,
    required this.node,
    this.onNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 24),
      width: double.infinity,
      child: Column(
        children: [
          // Card
          GestureDetector(
            onTap: () => onNavigate?.call('ignite'),
            child: Container(
              width: 320,
              decoration: BoxDecoration(
                color: AppColors.surfaceCard,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.forgeFire),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.forgeFire.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: -5,
                  )
                ],
              ),
              clipBehavior: Clip.antiAlias,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image / Banner Area
                  SizedBox(
                    height: 130,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Background Image Placement
                        Image.network(
                          'https://images.unsplash.com/photo-1535525153412-5a42439a210d?q=80&w=2070&auto=format&fit=crop',
                          fit: BoxFit.cover,
                          color: Colors.black.withOpacity(0.4),
                          colorBlendMode: BlendMode.darken,
                        ),

                        // Badge
                        Positioned(
                          top: 12,
                          left: 12,
                          child: FgBadge(
                            text: 'CURRENT LESSON',
                            variant: FgBadgeVariant.solid,
                            color: FgBadgeColor.brand,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Content
                  Container(
                    padding: const EdgeInsets.all(16),
                    child: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        // Play Button (Floating)
                        Positioned(
                          top: -40,
                          right: 0,
                          child: FgIconButton(
                            icon: Icons.play_arrow,
                            variant: FgIconButtonVariant.primary,
                            size: FgIconButtonSize.lg,
                            onPressed: () => onNavigate?.call('ignite'),
                          ),
                        ),

                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              node.type.name.toUpperCase(),
                              style: TextStyle(
                                fontFamily: 'Bebas Neue',
                                fontSize: 12,
                                color: AppColors.forgeFire,
                                letterSpacing: 2,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              node.title.toUpperCase(),
                              style: const TextStyle(
                                fontFamily: 'Bebas Neue',
                                fontSize: 24,
                                color: Colors.white,
                                letterSpacing: 1,
                                height: 1.0,
                              ),
                            ),
                            const SizedBox(height: 12),
                            Row(
                              children: [
                                Icon(Icons.schedule,
                                    size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  node.duration,
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                                Container(
                                  margin: const EdgeInsets.symmetric(
                                      horizontal: 12),
                                  width: 1,
                                  height: 12,
                                  color: Colors.white.withOpacity(0.2),
                                ),
                                Icon(Icons.bar_chart,
                                    size: 14, color: AppColors.textMuted),
                                const SizedBox(width: 4),
                                Text(
                                  node.difficulty,
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),

                            // Progress
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Progress',
                                  style: TextStyle(
                                      fontSize: 11, color: AppColors.textMuted),
                                ),
                                Text(
                                  '${(node.progress * 100).toInt()}%',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            FgProgressBar(
                              value: node.progress,
                              height: 4,
                              backgroundColor: Colors.white.withOpacity(0.1),
                              color: AppColors.forgeFire,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 48), // Spacing after card
        ],
      ),
    );
  }
}
