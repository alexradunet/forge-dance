import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/progress/radial_progress_ring.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: RadialProgressRing,
  path: 'Design System/Molecules/Progress',
)
Widget buildRadialProgressRingDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: RadialProgressRing(
        level: 42,
        progress: 0.75,
        subtitle: '+12% This Week',
        size: 200,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Low Level',
  type: RadialProgressRing,
  path: '[Molecules]/Progress',
)
Widget buildRadialProgressRingLow(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: RadialProgressRing(
        level: 8,
        progress: 0.25,
        subtitle: 'Keep going!',
        size: 200,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Max Level',
  type: RadialProgressRing,
  path: '[Molecules]/Progress',
)
Widget buildRadialProgressRingMax(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: RadialProgressRing(
        level: 99,
        progress: 0.95,
        subtitle: 'LEGENDARY',
        size: 200,
      ),
    ),
  );
}
