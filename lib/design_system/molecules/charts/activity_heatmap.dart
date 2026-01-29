import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';

/// Activity level for a single day
enum ActivityLevel { none, low, medium, high, max }

/// Activity heatmap grid showing daily activity over time
class ActivityHeatmapGrid extends StatelessWidget {
  /// 2D list of activity levels [week][day]
  final List<List<ActivityLevel>> data;
  final String? title;
  final String? subtitle;

  const ActivityHeatmapGrid({
    super.key,
    required this.data,
    this.title,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.4),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.4),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? 'ACTIVITY LOG',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: TextStyle(
                    fontSize: 10,
                    color: AppColors.textMuted,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          // Heatmap grid
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: data.map((week) {
                return Padding(
                  padding: const EdgeInsets.only(right: 4),
                  child: Column(
                    children: week.map((level) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: _ActivityCell(level: level),
                      );
                    }).toList(),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 12),
          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                'Less',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
              const SizedBox(width: 4),
              ...ActivityLevel.values.map((level) {
                return Padding(
                  padding: const EdgeInsets.only(left: 2),
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _getColorForLevel(level),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                );
              }),
              const SizedBox(width: 4),
              Text(
                'More',
                style: TextStyle(fontSize: 9, color: AppColors.textMuted),
              ),
            ],
          ),
        ],
      ),
    );
  }

  static Color _getColorForLevel(ActivityLevel level) {
    switch (level) {
      case ActivityLevel.none:
        return Colors.white.withOpacity(0.05);
      case ActivityLevel.low:
        return AppColors.forgeFire.withOpacity(0.2);
      case ActivityLevel.medium:
        return AppColors.forgeFire.withOpacity(0.4);
      case ActivityLevel.high:
        return AppColors.forgeFire.withOpacity(0.7);
      case ActivityLevel.max:
        return AppColors.forgeFire;
    }
  }
}

class _ActivityCell extends StatelessWidget {
  final ActivityLevel level;

  const _ActivityCell({required this.level});

  @override
  Widget build(BuildContext context) {
    final color = ActivityHeatmapGrid._getColorForLevel(level);
    final hasGlow = level == ActivityLevel.max || level == ActivityLevel.high;

    return Container(
      width: 12,
      height: 12,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
        boxShadow: hasGlow
            ? [
                BoxShadow(
                  color: AppColors.forgeFire.withOpacity(0.5),
                  blurRadius: 4,
                ),
              ]
            : null,
      ),
    );
  }
}

/// Generate mock heatmap data for demo
List<List<ActivityLevel>> generateMockHeatmapData({int weeks = 12}) {
  final random = DateTime.now().millisecondsSinceEpoch;
  return List.generate(weeks, (weekIndex) {
    return List.generate(7, (dayIndex) {
      final value = (random + weekIndex * 7 + dayIndex) % 5;
      return ActivityLevel.values[value];
    });
  });
}
