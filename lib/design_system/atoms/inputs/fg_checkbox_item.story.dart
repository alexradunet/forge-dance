import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgCheckboxItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgCheckboxItem(
        state: context.knobs.list(
          label: 'State',
          options: CheckboxState.values,
          initialOption: CheckboxState.checked,
        ),
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        onTap: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgCheckboxItem,
  path: 'Design System/Atoms/Inputs',
)
Widget buildCheckboxShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _CheckboxSection(
            title: 'Individual States',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const FgCheckboxItem(state: CheckboxState.unchecked),
                  const SizedBox(width: 24),
                  const FgCheckboxItem(state: CheckboxState.checked),
                  const SizedBox(width: 24),
                  const FgCheckboxItem(state: CheckboxState.indeterminate),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          _CheckboxSection(
            title: 'List Items',
            children: [
              CheckboxListItem(
                title: 'Accept Terms',
                subtitle: 'I agree to the terms and conditions',
                state: CheckboxState.checked,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              CheckboxListItem(
                title: 'Subscribe',
                subtitle: 'Receive newsletters and updates',
                state: CheckboxState.unchecked,
                onTap: () {},
              ),
              const SizedBox(height: 8),
              const CheckboxListItem(
                title: 'Disabled Option',
                subtitle: 'This cannot be changed',
                state: CheckboxState.unchecked,
                isEnabled: false,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _CheckboxSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _CheckboxSection({required this.title, required this.children});

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
