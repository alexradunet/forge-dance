import 'package:flutter/material.dart';
import '../../tokens/app_colors.dart';
import '../../organisms/lessons/lesson_node_models.dart';

class LessonTimelineBossNode extends StatelessWidget {
  final LessonNode node;

  const LessonTimelineBossNode({
    super.key,
    required this.node,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 24, bottom: 96),
      child: Column(
        children: [
          // Glowing Icon
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  AppColors.surfaceDark,
                  Colors.black,
                ],
              ),
              border: Border.all(color: AppColors.legendGold.withOpacity(0.4)),
              boxShadow: [
                BoxShadow(
                  color: AppColors.legendGold.withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.emoji_events,
                  color: AppColors.legendGold,
                  size: 36,
                ),
                Positioned(
                  bottom: -2,
                  right: -2,
                  child: Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white.withOpacity(0.1)),
                    ),
                    child:
                        Icon(Icons.lock, size: 14, color: AppColors.textMuted),
                  ),
                )
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Text
          Text(
            'FINAL CHALLENGE',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.bold,
              color: AppColors.legendGold,
              letterSpacing: 2,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'BOSS SHOWCASE',
            style: TextStyle(
              fontFamily: 'Bebas Neue',
              fontSize: 32,
              color: Colors.white,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 160,
            child: Text(
              'Combine all elements to unlock the next module.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                color: AppColors.textMuted,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
