import 'package:flutter/material.dart';

import '../../../design_system/tokens/app_colors.dart';

/// Data point for weekly performance
class PerformanceDataPoint {
  final String label;
  final double fpEarned; // 0.0 to 1.0 normalized
  final double practiceTime; // 0.0 to 1.0 normalized
  final bool isToday;

  const PerformanceDataPoint({
    required this.label,
    required this.fpEarned,
    required this.practiceTime,
    this.isToday = false,
  });
}

/// Weekly performance bar chart
class WeeklyPerformanceChart extends StatelessWidget {
  final List<PerformanceDataPoint> data;
  final String? title;

  const WeeklyPerformanceChart({
    super.key,
    required this.data,
    this.title,
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
                title ?? 'PERFORMANCE',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 1,
                ),
              ),
              // Legend
              Row(
                children: [
                  _LegendItem(
                    color: AppColors.forgeFire,
                    label: 'FP Earned',
                  ),
                  const SizedBox(width: 12),
                  _LegendItem(
                    color: Colors.white.withOpacity(0.2),
                    label: 'Practice Time',
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Chart
          SizedBox(
            height: 128,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: data.map((point) {
                return Expanded(
                  child: _BarGroup(data: point),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _BarGroup extends StatelessWidget {
  final PerformanceDataPoint data;

  const _BarGroup({required this.data});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // FP Earned bar
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: data.fpEarned.clamp(0.05, 1.0),
                    child: Container(
                      width: 12,
                      decoration: BoxDecoration(
                        color: AppColors.forgeFire,
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                        boxShadow: data.isToday
                            ? [
                                BoxShadow(
                                  color: AppColors.forgeFire.withOpacity(0.5),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 2),
                // Practice Time bar
                Flexible(
                  child: FractionallySizedBox(
                    heightFactor: data.practiceTime.clamp(0.05, 1.0),
                    child: Container(
                      width: 12,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: const BorderRadius.vertical(
                          top: Radius.circular(2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            data.label,
            style: TextStyle(
              fontSize: 9,
              fontWeight: data.isToday ? FontWeight.bold : FontWeight.normal,
              color: data.isToday ? Colors.white : AppColors.textMuted,
            ),
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: AppColors.textMuted,
          ),
        ),
      ],
    );
  }
}

/// Generate mock weekly performance data
List<PerformanceDataPoint> generateMockPerformanceData() {
  return const [
    PerformanceDataPoint(label: 'M', fpEarned: 0.4, practiceTime: 0.3),
    PerformanceDataPoint(label: 'T', fpEarned: 0.65, practiceTime: 0.45),
    PerformanceDataPoint(label: 'W', fpEarned: 0.25, practiceTime: 0.5),
    PerformanceDataPoint(label: 'T', fpEarned: 0.8, practiceTime: 0.6, isToday: true),
    PerformanceDataPoint(label: 'F', fpEarned: 0.5, practiceTime: 0.2),
    PerformanceDataPoint(label: 'S', fpEarned: 0.3, practiceTime: 0.1),
    PerformanceDataPoint(label: 'S', fpEarned: 0.45, practiceTime: 0.4),
  ];
}
