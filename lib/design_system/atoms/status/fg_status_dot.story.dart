import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgStatusDotPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgStatusDot(
        isLive: context.knobs.boolean(label: 'Is Live', initialValue: true),
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 12, min: 4, max: 32),
        color: context.knobs.colorOrNull(label: 'Color'),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgStatusDot,
  path: 'Design System/Atoms',
)
Widget buildFgStatusDotShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Live',
                  style: AppTheme.caption.copyWith(color: Colors.white54)),
              const SizedBox(height: 16),
              const FgStatusDot(isLive: true),
            ],
          ),
          const SizedBox(width: 48),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Offline',
                  style: AppTheme.caption.copyWith(color: Colors.white54)),
              const SizedBox(height: 16),
              const FgStatusDot(isLive: false),
            ],
          ),
        ],
      ),
    ),
  );
}
