import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/charts/weekly_performance_chart.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: WeeklyPerformanceChart,
  path: '[Molecules]/Charts',
)
Widget buildWeeklyPerformanceChartDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: WeeklyPerformanceChart(
          data: generateMockPerformanceData(),
          title: 'PERFORMANCE',
        ),
      ),
    ),
  );
}
