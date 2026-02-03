import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLevelBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildFgLevelBadgePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgLevelBadge(
        level: context.knobs.int
            .slider(label: 'Level', initialValue: 5, min: 1, max: 99),
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 32, min: 16, max: 64),
        showGlow: context.knobs.boolean(label: 'Show Glow', initialValue: true),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgLevelBadge,
  path: 'Design System/Atoms/Badges',
)
Widget buildFgLevelBadgeShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Sizes', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                FgLevelBadge(level: 1, size: 20),
                SizedBox(width: 16),
                FgLevelBadge(level: 12, size: 32),
                SizedBox(width: 16),
                FgLevelBadge(level: 50, size: 48),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Usage Context (Avatar)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Stack(
              clipBehavior: Clip.none,
              children: [
                const CircleAvatar(
                  radius: 32,
                  backgroundImage:
                      NetworkImage('https://i.pravatar.cc/150?img=12'),
                ),
                const Positioned(
                  bottom: -4,
                  right: -4,
                  child: FgLevelBadge(level: 15, size: 24),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
