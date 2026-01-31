import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/buttons/app_button.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppButton,
  path: 'Design System/Atoms/AppButton',
)
Widget buildAppButtonPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppButton(
        text: context.knobs.string(label: 'Text', initialValue: 'Click Me'),
        variant: context.knobs.list(
          label: 'Variant',
          options: AppButtonVariant.values,
          initialOption: AppButtonVariant.primary,
        ),
        size: context.knobs.list(
          label: 'Size',
          options: AppButtonSize.values,
          initialOption: AppButtonSize.md,
        ),
        shape: context.knobs.listOrNull(
          label: 'Shape',
          options: AppButtonShape.values,
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
  type: AppButton,
  path: 'Design System/Atoms/AppButton',
)
Widget buildAppButtonAllVariants(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: AppButtonVariant.values.map((variant) {
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
                  AppButton(
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
  type: AppButton,
  path: 'Design System/Atoms/AppButton',
)
Widget buildAppButtonAllSizes(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: AppButtonSize.values.map((size) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: AppButton(
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
  type: AppButton,
  path: 'Design System/Atoms/AppButton',
)
Widget buildAppButtonFabIcon(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // FAB
          AppButton(
            icon: const Icon(Icons.add),
            size: AppButtonSize.xl,
            shape: AppButtonShape.circle,
            variant: AppButtonVariant.primary,
            onPressed: () {},
          ),
          const SizedBox(width: 24),
          // Icon Button
          AppButton(
            icon: const Icon(Icons.settings),
            size: AppButtonSize.md,
            shape: AppButtonShape.circle,
            variant: AppButtonVariant.secondary,
            onPressed: () {},
          ),
          const SizedBox(width: 24),
          // Ghost Icon
          AppButton(
            icon: const Icon(Icons.close),
            size: AppButtonSize.md,
            variant: AppButtonVariant.ghost,
            onPressed: () {},
          ),
        ],
      ),
    ),
  );
}
