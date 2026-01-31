import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'New',
  type: StatusBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildStatusBadgeNew(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: StatusBadge(
        label: 'New',
        type: StatusBadgeType.new_,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Trending',
  type: StatusBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildStatusBadgeTrending(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: StatusBadge(
        label: 'Trending',
        type: StatusBadgeType.trending,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Locked',
  type: StatusBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildStatusBadgeLocked(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: StatusBadge(
        label: 'Locked',
        type: StatusBadgeType.locked,
      ),
    ),
  );
}
