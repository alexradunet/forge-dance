import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Live',
  type: StatusDot,
  path: 'Design System/Atoms/Status',
)
Widget buildStatusDotLive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: StatusDot(isLive: true),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Offline',
  type: StatusDot,
  path: 'Design System/Atoms/Status',
)
Widget buildStatusDotOffline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: StatusDot(isLive: false),
    ),
  );
}
