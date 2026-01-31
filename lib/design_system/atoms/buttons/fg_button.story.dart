import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgButton,
  path: 'Design System/Atoms',
)
Widget buildFgButtonPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgButton(
        text: context.knobs.string(label: 'Text', initialValue: 'Click Me'),
        variant: context.knobs.list(
          label: 'Variant',
          options: FgButtonVariant.values,
          initialOption: FgButtonVariant.primary,
        ),
        size: context.knobs.list(
          label: 'Size',
          options: FgButtonSize.values,
          initialOption: FgButtonSize.md,
        ),
        shape: context.knobs.listOrNull(
          label: 'Shape',
          options: FgButtonShape.values,
          initialOption: null,
        ),
        isLoading:
            context.knobs.boolean(label: 'Is Loading', initialValue: false),
        isEnabled:
            context.knobs.boolean(label: 'Is Enabled', initialValue: true),
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgButton,
  path: 'Design System/Atoms',
)
Widget buildFgButtonShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          _ButtonSection(
            title: 'Variants',
            children: FgButtonVariant.values.map((v) {
              return FgButton(
                  text: v.name.toUpperCase(), variant: v, onPressed: () {});
            }).toList(),
          ),
          const SizedBox(height: 48),
          _ButtonSection(
            title: 'Sizes',
            children: FgButtonSize.values.map((s) {
              return FgButton(
                  text: s.name.toUpperCase(), size: s, onPressed: () {});
            }).toList(),
          ),
          const SizedBox(height: 48),
          const _ButtonSection(
            title: 'Special Types',
            children: [
              // FAB
              FgButton(
                icon: Icon(Icons.add),
                size: FgButtonSize.xl,
                shape: FgButtonShape.circle,
                onPressed: null,
              ),
              // Pill
              FgButton(
                text: 'PILL SHAPE',
                shape: FgButtonShape.pill,
                onPressed: null,
              ),
              // Loading
              FgButton(
                text: 'LOADING',
                isLoading: true,
                onPressed: null,
              ),
              // Disabled
              FgButton(
                text: 'DISABLED',
                isEnabled: false,
                onPressed: null,
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _ButtonSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _ButtonSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: AppTypography.h4
                .copyWith(color: AppColors.crystalWhite, letterSpacing: 1.2)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          alignment: WrapAlignment.center,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: children,
        ),
      ],
    );
  }
}
