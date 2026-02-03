import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgAspectRatio,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgAspectRatioPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgAspectRatio(
          ratio: context.knobs.list(
            label: 'Ratio',
            options: [16 / 9, 4 / 3, 1.0, 9 / 16],
            initialOption: 16 / 9,
          ),
          child: Container(
            color: AppColors.electricBlue,
            child: const Center(
              child: Icon(Icons.aspect_ratio, color: Colors.white, size: 48),
            ),
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgAspectRatio,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgAspectRatioShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Video (16:9)', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        FgAspectRatio.video(
          child: Container(color: AppColors.forgeFire),
        ),
        const SizedBox(height: 24),
        const Text('Photo (4:3)', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        SizedBox(
          width: 200, // Constrain width to see ratio
          child: FgAspectRatio.photo(
            child: Container(color: AppColors.growthGreen),
          ),
        ),
        const SizedBox(height: 24),
        const Text('Square (1:1)', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 8),
        SizedBox(
          width: 100,
          child: FgAspectRatio.square(
            child: Container(color: AppColors.legendGold),
          ),
        ),
      ],
    ),
  );
}
