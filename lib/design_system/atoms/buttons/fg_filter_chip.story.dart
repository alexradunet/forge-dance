import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgFilterChip,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFgFilterChipPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgFilterChip(
        label: context.knobs.string(label: 'Label', initialValue: 'Hip Hop'),
        isSelected:
            context.knobs.boolean(label: 'Selected', initialValue: true),
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        icon: context.knobs.listOrNull(
          label: 'Icon',
          options: [Icons.music_note, Icons.filter_list, Icons.star],
          initialOption: null,
        ),
        onSelected: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgFilterChip,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFgFilterChipShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Standard Chips', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FgFilterChip(
                    label: 'All', isSelected: true, onSelected: (_) {}),
                FgFilterChip(
                    label: 'Popping', isSelected: false, onSelected: (_) {}),
                FgFilterChip(
                    label: 'Locking', isSelected: false, onSelected: (_) {}),
                FgFilterChip(
                    label: 'Breaking', isSelected: false, onSelected: (_) {}),
              ],
            ),
            const SizedBox(height: 32),
            const Text('With Icons', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FgFilterChip(
                  label: 'Premium',
                  icon: Icons.star,
                  isSelected: true,
                  onSelected: (_) {},
                ),
                FgFilterChip(
                  label: 'Filter',
                  icon: Icons.filter_list,
                  isSelected: false,
                  onSelected: (_) {},
                ),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
