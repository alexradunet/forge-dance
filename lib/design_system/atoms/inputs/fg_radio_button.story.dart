import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgRadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildRadioButtonPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgRadioButton(
        isSelected:
            context.knobs.boolean(label: 'Selected', initialValue: true),
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgRadioButton,
  path: 'Design System/Atoms/Inputs',
)
Widget buildRadioButtonShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _RadioSection(
            title: 'Individual Buttons',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FgRadioButton(isSelected: false),
                  const SizedBox(width: 32),
                  const FgRadioButton(isSelected: true),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          _RadioSection(
            title: 'List Items',
            children: [
              RadioListItem(
                label: 'Option 1 - Selected',
                isSelected: true,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              RadioListItem(
                label: 'Option 2 - Unselected',
                isSelected: false,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const RadioListItem(
                label: 'Option 3 - Disabled',
                isSelected: false,
                isEnabled: false,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _RadioSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _RadioSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.h5.copyWith(color: AppColors.crystalWhite)),
        const SizedBox(height: 24),
        ...children,
      ],
    );
  }
}
