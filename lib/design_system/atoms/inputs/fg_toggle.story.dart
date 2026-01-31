import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgToggle,
  path: 'Design System/Atoms/Inputs',
)
Widget buildTogglePlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgToggle(
        value: context.knobs.boolean(label: 'Value', initialValue: true),
        onChanged: (_) {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgToggle,
  path: 'Design System/Atoms/Inputs',
)
Widget buildToggleShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ToggleSection(
            title: 'Individual Toggles',
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FgToggle(value: false, onChanged: (_) {}),
                  const SizedBox(width: 32),
                  FgToggle(value: true, onChanged: (_) {}),
                ],
              ),
            ],
          ),
          const SizedBox(height: 48),
          const _ToggleSection(
            title: 'List Items',
            children: [
              ToggleListItem(
                title: 'Enable Notifications',
                subtitle: 'Receive push notifications for updates',
                value: true,
              ),
              SizedBox(height: 8),
              ToggleListItem(
                title: 'Dark Mode',
                subtitle: 'Toggle between light and dark themes',
                value: false,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ToggleSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ToggleSection({required this.title, required this.children});

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
