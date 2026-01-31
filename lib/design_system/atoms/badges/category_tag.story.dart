import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Hip-Hop',
  type: CategoryTag,
  path: 'Design System/Atoms/Badges',
)
Widget buildCategoryTagHipHop(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: CategoryTag(
        label: 'Hip-Hop',
        preset: CategoryTagPreset.hipHop,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Breaking',
  type: CategoryTag,
  path: 'Design System/Atoms/Badges',
)
Widget buildCategoryTagBreaking(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: CategoryTag(
        label: 'Breaking',
        preset: CategoryTagPreset.breaking,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Contemporary',
  type: CategoryTag,
  path: 'Design System/Atoms/Badges',
)
Widget buildCategoryTagContemporary(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: CategoryTag(
        label: 'Contemporary',
        preset: CategoryTagPreset.contemporary,
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Selected State',
  type: CategoryTag,
  path: 'Design System/Atoms/Badges',
)
Widget buildCategoryTagSelected(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CategoryTag(
            label: 'Hip-Hop',
            preset: CategoryTagPreset.hipHop,
            isSelected: true,
            onTap: () {},
          ),
          const SizedBox(width: 8),
          CategoryTag(
            label: 'Breaking',
            preset: CategoryTagPreset.breaking,
            onTap: () {},
          ),
        ],
      ),
    ),
  );
}
