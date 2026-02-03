import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgIconButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFgIconButtonPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgIconButton(
        icon: context.knobs.list(
          label: 'Icon',
          options: [
            Icons.favorite,
            Icons.share,
            Icons.bookmark,
            Icons.arrow_back,
            Icons.close
          ],
          initialOption: Icons.favorite,
        ),
        variant: context.knobs.list(
          label: 'Variant',
          options: FgIconButtonVariant.values,
          initialOption: FgIconButtonVariant.glass,
        ),
        size: context.knobs.list(
          label: 'Size',
          options: FgIconButtonSize.values,
          initialOption: FgIconButtonSize.md,
        ),
        isEnabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
        isLoading:
            context.knobs.boolean(label: 'Is Loading', initialValue: false),
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgIconButton,
  path: 'Design System/Atoms/Buttons',
)
Widget buildFgIconButtonShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const Text('Variants', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              children: [
                FgIconButton(
                  icon: Icons.add,
                  variant: FgIconButtonVariant.primary,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.edit,
                  variant: FgIconButtonVariant.secondary,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.close,
                  variant: FgIconButtonVariant.glass,
                  onPressed: () {},
                ),
                FgIconButton(
                  icon: Icons.info_outline,
                  variant: FgIconButtonVariant.ghost,
                  onPressed: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Sizes', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 16,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                FgIconButton(
                    icon: Icons.star,
                    size: FgIconButtonSize.sm,
                    onPressed: () {}),
                FgIconButton(
                    icon: Icons.star,
                    size: FgIconButtonSize.md,
                    onPressed: () {}),
                FgIconButton(
                    icon: Icons.star,
                    size: FgIconButtonSize.lg,
                    onPressed: () {}),
                FgIconButton(
                    icon: Icons.star,
                    size: FgIconButtonSize.xl,
                    onPressed: () {}),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Factories', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FgIconButton.back(onPressed: () {}),
                const SizedBox(width: 16),
                FgIconButton.close(onPressed: () {}),
              ],
            ),
          ],
        ),
      ),
    ),
  );
}
