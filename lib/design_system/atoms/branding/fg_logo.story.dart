import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/branding/fg_logo.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLogo,
  path: 'Design System/Atoms/Branding',
)
Widget buildFgLogoPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgLogo(
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 48, min: 16, max: 200),
        variant: context.knobs.list(
          label: 'Variant',
          options: FgLogoVariant.values,
          initialOption: FgLogoVariant.full,
        ),
        color: context.knobs.list(
          label: 'Color',
          options: FgLogoColor.values,
          initialOption: FgLogoColor.brand,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgLogo,
  path: 'Design System/Atoms/Branding',
)
Widget buildFgLogoShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('Variants (Brand)',
                style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Wrap(
              spacing: 32,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                FgLogo(variant: FgLogoVariant.iconOnly, size: 40),
                FgLogo(variant: FgLogoVariant.textOnly, size: 40),
                FgLogo(variant: FgLogoVariant.full, size: 40),
              ],
            ),
            const SizedBox(height: 32),
            const Text('Colors', style: TextStyle(color: Colors.white)),
            const SizedBox(height: 16),
            Container(
              color: Colors.white10,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [
                  FgLogo(
                      variant: FgLogoVariant.iconOnly,
                      color: FgLogoColor.brand),
                  FgLogo(
                      variant: FgLogoVariant.iconOnly,
                      color: FgLogoColor.white),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Container(
              color: Colors.white70,
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  FgLogo(
                      variant: FgLogoVariant.iconOnly,
                      color: FgLogoColor.black),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
