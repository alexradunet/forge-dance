import 'package:flutter/material.dart';

import '../../../../design_system/tokens/app_colors.dart';

/// Achievement badge model
class Achievement {
  final String name;
  final IconData icon;
  final bool isUnlocked;

  const Achievement({
    required this.name,
    required this.icon,
    this.isUnlocked = true,
  });
}

/// Single achievement badge widget
class AchievementBadge extends StatelessWidget {
  final Achievement achievement;

  const AchievementBadge({
    super.key,
    required this.achievement,
  });

  @override
  Widget build(BuildContext context) {
    final isUnlocked = achievement.isUnlocked;

    return SizedBox(
      width: 96,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: isUnlocked
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.surfaceDark,
                        Colors.black,
                      ],
                    )
                  : null,
              color: isUnlocked ? null : AppColors.surfaceDark,
              border: Border.all(
                color: isUnlocked
                    ? Colors.white.withOpacity(0.1)
                    : Colors.white.withOpacity(0.05),
              ),
              boxShadow: isUnlocked
                  ? [
                      BoxShadow(
                        color: AppColors.legendGold.withOpacity(0.1),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: isUnlocked
                  ? Icon(
                      achievement.icon,
                      size: 40,
                      color: AppColors.legendGold,
                      shadows: [
                        Shadow(
                          color: AppColors.legendGold.withOpacity(0.5),
                          blurRadius: 10,
                        ),
                      ],
                    )
                  : Icon(
                      Icons.lock,
                      size: 36,
                      color: Colors.white.withOpacity(0.2),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            achievement.name,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: isUnlocked
                  ? AppColors.textMuted
                  : Colors.white.withOpacity(0.3),
            ),
          ),
        ],
      ),
    );
  }
}

/// Horizontal scrolling achievements carousel
class AchievementsCarousel extends StatelessWidget {
  final List<Achievement> achievements;
  final VoidCallback? onViewAll;

  const AchievementsCarousel({
    super.key,
    required this.achievements,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'MY ACHIEVEMENTS',
                style: TextStyle(
                  fontFamily: 'Bebas Neue',
                  fontSize: 20,
                  color: Colors.white,
                  letterSpacing: 1.5,
                ),
              ),
              if (onViewAll != null)
                GestureDetector(
                  onTap: onViewAll,
                  child: Text(
                    'VIEW ALL',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: AppColors.forgeFire,
                      letterSpacing: 1.5,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 120,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 24),
            itemCount: achievements.length,
            separatorBuilder: (_, __) => const SizedBox(width: 16),
            itemBuilder: (context, index) {
              return AchievementBadge(achievement: achievements[index]);
            },
          ),
        ),
      ],
    );
  }
}
