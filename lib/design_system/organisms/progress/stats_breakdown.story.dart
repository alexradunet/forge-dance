import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/organisms/progress/stats_breakdown.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Stats Breakdown',
  type: StatsBreakdown,
  path: 'Design System/Organisms/Progress',
)
Widget buildStatsBreakdown(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: StatsBreakdown(
          totalXP:
              context.knobs.int.input(label: 'Total XP', initialValue: 12500),
          trend: context.knobs.string(label: 'Trend', initialValue: '+12%'),
          isPositiveTrend: context.knobs
              .boolean(label: 'Positive Trend', initialValue: true),
          weeklyGoal:
              context.knobs.int.input(label: 'Weekly Goal', initialValue: 5000),
          rank: context.knobs.int.input(label: 'Rank', initialValue: 42),
        ),
      ),
    ),
  );
}
