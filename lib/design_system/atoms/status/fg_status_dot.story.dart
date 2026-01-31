import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Live',
  type: FgFgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgFgStatusDotLive(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgFgStatusDot(isLive: true),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Offline',
  type: FgFgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgFgStatusDotOffline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgFgStatusDot(isLive: false),
    ),
  );
}
