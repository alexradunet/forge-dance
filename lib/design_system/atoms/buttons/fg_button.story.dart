import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/buttons/fg_button.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

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
  name: 'All Variants',
  type: FgButton,
  path: 'Design System/Atoms',
)
Widget buildFgButtonAllVariants(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: FgButtonVariant.values.map((variant) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Text(
                    variant.name.toUpperCase(),
                    style: const TextStyle(
                        color: AppColors.textMain, fontSize: 10),
                  ),
                  const SizedBox(height: 8),
                  FgButton(
                    text: 'Button',
                    variant: variant,
                    onPressed: () {},
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'All Sizes',
  type: FgButton,
  path: 'Design System/Atoms',
)
Widget buildFgButtonAllSizes(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: FgButtonSize.values.map((size) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: FgButton(
              text: 'Size ${size.name}',
              icon: const Icon(Icons.add),
              size: size,
              onPressed: () {},
            ),
          );
        }).toList(),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'FAB & Icon Buttons',
  type: FgButton,
  path: 'Design System/Atoms',
)
Widget buildFgButtonFabIcon(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FAB
          FgButton(
            icon: const Icon(Icons.add),
            size: FgButtonSize.xl,
            shape: FgButtonShape.circle,
            variant: FgButtonVariant.primary,
            onPressed: () {},
          ),
          const SizedBox(width: 24),
          // Icon Button
          FgButton(
            icon: const Icon(Icons.settings),
            size: FgButtonSize.md,
            shape: FgButtonShape.circle,
            variant: FgButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(width: 24),
          // Ghost Icon
          FgButton(
            icon: const Icon(Icons.close),
            size: FgButtonSize.md,
            variant: FgButtonVariant.ghost,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}
