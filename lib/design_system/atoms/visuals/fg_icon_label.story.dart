import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_icon_label.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgIconLabel,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgIconLabelPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgIconLabel(
        icon: context.knobs.list(
          label: 'Icon',
          options: [
            Icons.style,
            Icons.timer,
            Icons.flash_on,
            Icons.fitness_center,
          ],
          initialOption: Icons.style,
        ),
        label: context.knobs.string(
          label: 'Label',
          initialValue: 'STYLE',
        ),
        value: context.knobs.string(
          label: 'Value',
          initialValue: 'HIP HOP',
        ),
        iconColor: context.knobs.color(
          label: 'Icon Color',
          initialValue: Colors.blueAccent,
        ),
        labelColor: context.knobs.color(
          label: 'Label Color',
          initialValue: AppColors.textDark,
        ),
        valueColor: context.knobs.color(
          label: 'Value Color',
          initialValue: Colors.white,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgIconLabel,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgIconLabelShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black.withOpacity(0.5),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const FgIconLabel(
              icon: Icons.style,
              label: 'STYLE',
              value: 'HIP HOP',
              iconColor: Colors.blueAccent,
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const FgIconLabel(
              icon: Icons.signal_cellular_alt,
              label: 'DIFFICULTY',
              value: 'ADVANCED',
              iconColor: Colors.greenAccent,
            ),
            Container(
              width: 1,
              height: 24,
              color: Colors.white.withOpacity(0.1),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            const FgIconLabel(
              icon: Icons.timer,
              label: 'TIME',
              value: '45 MIN',
              iconColor: AppColors.forgeFire,
            ),
          ],
        ),
      ),
    ),
  );
}
