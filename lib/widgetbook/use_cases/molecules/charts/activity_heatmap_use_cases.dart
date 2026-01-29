import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/charts/activity_heatmap.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ActivityHeatmapGrid,
  path: '[Molecules]/Charts',
)
Widget buildActivityHeatmapDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ActivityHeatmapGrid(
          data: generateMockHeatmapData(weeks: 12),
          title: 'ACTIVITY LOG',
          subtitle: 'Last 3 Months',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Weekly',
  type: ActivityHeatmapGrid,
  path: '[Molecules]/Charts',
)
Widget buildActivityHeatmapWeekly(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: ActivityHeatmapGrid(
          data: generateMockHeatmapData(weeks: 4),
          title: 'THIS MONTH',
          subtitle: 'Last 4 Weeks',
        ),
      ),
    ),
  );
}
