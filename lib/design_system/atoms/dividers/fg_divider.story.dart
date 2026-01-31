import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgDivider,
  path: 'Design System/Atoms',
)
Widget buildFgDividerPlayground(BuildContext context) {
  final isVertical =
      context.knobs.boolean(label: 'Is Vertical', initialValue: false);

  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: isVertical
            ? SizedBox(height: 200, child: FgDivider.vertical())
            : FgDivider(),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgDivider,
  path: 'Design System/Atoms',
)
Widget buildFgDividerShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Horizontal', style: AppTheme.h5.copyWith(color: Colors.white)),
          const SizedBox(height: 24),
          FgDivider(),
          const SizedBox(height: 48),
          Text('Vertical', style: AppTheme.h5.copyWith(color: Colors.white)),
          const SizedBox(height: 24),
          SizedBox(
            height: 100,
            child: Row(
              children: [
                const Text('Left', style: TextStyle(color: Colors.white54)),
                const SizedBox(width: 24),
                FgDivider.vertical(),
                const SizedBox(width: 24),
                const Text('Right', style: TextStyle(color: Colors.white54)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}
