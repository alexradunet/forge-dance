import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Beginner Solid',
  type: DifficultyBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildDifficultyBadgeBeginnerSolid(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: DifficultyBadge(
        level: DifficultyLevel.beginner,
        isOutlined: false,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Intermediate Outlined',
  type: DifficultyBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildDifficultyBadgeIntermediateOutlined(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: DifficultyBadge(
        level: DifficultyLevel.intermediate,
        isOutlined: true,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Advanced Solid',
  type: DifficultyBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildDifficultyBadgeAdvancedSolid(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: DifficultyBadge(
        level: DifficultyLevel.advanced,
        isOutlined: false,
      ),
    ),
  );
}
