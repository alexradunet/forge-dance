import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgShimmer,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgShimmerPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgShimmer(
        width: context.knobs.double
            .slider(label: 'Width', initialValue: 200, min: 50, max: 400),
        height: context.knobs.double
            .slider(label: 'Height', initialValue: 100, min: 20, max: 300),
        baseColor: context.knobs
            .color(label: 'Base Color', initialValue: AppColors.gray800),
        highlightColor: context.knobs
            .color(label: 'Highlight Color', initialValue: AppColors.gray700),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgShimmer,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgShimmerShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Profile', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        Row(
          children: [
            FgShimmer.circle(size: 64),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FgShimmer.rect(width: 150, height: 20),
                const SizedBox(height: 8),
                FgShimmer.rect(width: 100, height: 14),
              ],
            ),
          ],
        ),
        const SizedBox(height: 32),
        const Text('Card Loading', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        FgShimmer.rect(
          width: double.infinity,
          height: 180,
          borderRadius: 16,
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FgShimmer.rect(width: 80, height: 32, borderRadius: 16),
            FgShimmer.rect(width: 80, height: 32, borderRadius: 16),
          ],
        ),
      ],
    ),
  );
}
