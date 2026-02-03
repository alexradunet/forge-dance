import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgTooltip,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgTooltipPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgTooltip(
        message: context.knobs.string(
            label: 'Message', initialValue: 'This is a helpful tooltip'),
        child: const Icon(Icons.info, color: Colors.white, size: 32),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgTooltip,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgTooltipShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text('Long press or hover items below',
              style: TextStyle(color: Colors.white54)),
          SizedBox(height: 32),
          FgTooltip(
            message: 'Edit Profile',
            child: Icon(Icons.edit, color: Colors.white),
          ),
          SizedBox(height: 32),
          FgTooltip(
            message: 'Level 42: Master Breaker',
            child: FgLevelBadge(level: 42),
          ),
        ],
      ),
    ),
  );
}
