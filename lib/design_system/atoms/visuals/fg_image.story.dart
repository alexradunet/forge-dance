import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgImage,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgImagePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgImage(
          imageUrl: context.knobs.string(
            label: 'Image URL',
            initialValue: 'https://picsum.photos/seed/dance/800/600',
          ),
          width: context.knobs.doubleOrNull
              .slider(label: 'Width', initialValue: 300, min: 50, max: 500),
          height: context.knobs.doubleOrNull
              .slider(label: 'Height', initialValue: 200, min: 50, max: 500),
          aspectRatio: context.knobs.doubleOrNull.slider(
              label: 'Aspect Ratio', initialValue: null, min: 0.5, max: 2.0),
          borderRadius: BorderRadius.circular(
            context.knobs.double
                .slider(label: 'Radius', initialValue: 16, min: 0, max: 50),
          ),
          fit: context.knobs.list(
            label: 'Fit',
            options: BoxFit.values,
            initialOption: BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgImage,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgImageShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: ListView(
      padding: const EdgeInsets.all(24),
      children: [
        const Text('Standard Card Image',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        FgImage(
          imageUrl: 'https://picsum.photos/seed/forge/800/400',
          height: 180,
          width: double.infinity,
          borderRadius: BorderRadius.circular(16),
        ),
        const SizedBox(height: 32),
        const Text('Avatar Style (Clipped)',
            style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        FgImage(
          imageUrl: 'https://i.pravatar.cc/300',
          width: 80,
          height: 80,
          borderRadius: BorderRadius.circular(40),
        ),
        const SizedBox(height: 32),
        const Text('Error State', style: TextStyle(color: Colors.white)),
        const SizedBox(height: 16),
        FgImage(
          imageUrl: 'https://invalid-url.com/missing.jpg',
          width: 150,
          height: 150,
          borderRadius: BorderRadius.circular(16),
        ),
      ],
    ),
  );
}
