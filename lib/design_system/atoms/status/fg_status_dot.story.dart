import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Live',
  type: FgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgStatusDotLive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStatusDot(isLive: true),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Offline',
  type: FgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgStatusDotOffline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStatusDot(isLive: false),
    ),
  );
}
