import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgRating,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgRatingPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgRating(
        value: context.knobs.double
            .slider(label: 'Value', initialValue: 3.5, min: 0, max: 5),
        itemCount: context.knobs.int
            .slider(label: 'Count', initialValue: 5, min: 3, max: 10),
        itemSize: context.knobs.double
            .slider(label: 'Size', initialValue: 32, min: 16, max: 64),
        color: context.knobs
            .color(label: 'Color', initialValue: AppColors.legendGold),
        onChanged:
            context.knobs.boolean(label: 'Interactive', initialValue: true)
                ? (_) {}
                : null,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgRating,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgRatingShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Read Only (4.5)', style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          const FgRating(value: 4.5, itemSize: 20),
          const SizedBox(height: 32),
          const Text('Interactive (Tap to change)',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          StatefulBuilder(
            builder: (context, setState) {
              double rating = 3.0;
              return FgRating(
                value: rating,
                itemSize: 40,
                onChanged: (val) {
                  setState(() => rating = val);
                },
              );
            },
          ),
          const SizedBox(height: 32),
          const Text('Custom Color & Size',
              style: TextStyle(color: Colors.white)),
          const SizedBox(height: 8),
          const FgRating(
            value: 5,
            itemCount: 5,
            itemSize: 16,
            color: AppColors.forgeFire,
          ),
        ],
      ),
    ),
  );
}
