import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppSizes,
  path: 'Design System/Tokens',
)
Widget buildSizesPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Container(
        width: context.knobs.double
            .slider(label: 'Size', initialValue: 44, min: 10, max: 200),
        height: context.knobs.double
            .slider(label: 'Size (H)', initialValue: 44, min: 10, max: 200),
        color: AppColors.forgeFire,
        child: const Center(child: Icon(Icons.touch_app, color: Colors.white)),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: AppSizes,
  path: 'Design System/Tokens',
)
Widget buildSizesShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SizeGroup(
              title: 'Icons',
              sizes: {
                'XS': AppSizes.iconXs,
                'SM': AppSizes.iconSm,
                'MD': AppSizes.iconMd,
                'LG': AppSizes.iconLg,
                'XL': AppSizes.iconXl,
                'XXL': AppSizes.iconXxl,
                'Huge': AppSizes.iconHuge,
              },
              isSquare: true),
          _SizeGroup(
              title: 'Buttons (Height)',
              sizes: {
                'XS': AppSizes.buttonXs,
                'SM': AppSizes.buttonSm,
                'MD': AppSizes.buttonMd,
                'LG': AppSizes.buttonLg,
                'XL': AppSizes.buttonXl,
              },
              isSquare: false),
          _SizeGroup(
              title: 'Inputs (Height)',
              sizes: {
                'SM': AppSizes.inputSm,
                'MD': AppSizes.inputMd,
                'LG': AppSizes.inputLg,
              },
              isSquare: false),
          _SizeGroup(
              title: 'Avatars',
              sizes: {
                'XS': AppSizes.avatarXs,
                'SM': AppSizes.avatarSm,
                'MD': AppSizes.avatarMd,
                'LG': AppSizes.avatarLg,
                'XL': AppSizes.avatarXl,
                'XXL': AppSizes.avatarXxl,
              },
              isSquare: true),
        ],
      ),
    ),
  );
}

class _SizeGroup extends StatelessWidget {
  final String title;
  final Map<String, double> sizes;
  final bool isSquare;

  const _SizeGroup(
      {required this.title, required this.sizes, required this.isSquare});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.h5.copyWith(color: Colors.white)),
        const SizedBox(height: 16),
        Wrap(
          spacing: 16,
          runSpacing: 16,
          crossAxisAlignment: WrapCrossAlignment.end,
          children: sizes.entries.map((e) {
            return Column(
              children: [
                Container(
                  width: isSquare ? e.value : 100,
                  height: e.value,
                  color: AppColors.gray700,
                  alignment: Alignment.center,
                  child: Text(
                    '${e.value.toInt()}',
                    style: TextStyle(fontSize: 10, color: Colors.white60),
                  ),
                ),
                const SizedBox(height: 4),
                Text(e.key,
                    style: AppTypography.caption
                        .copyWith(color: AppColors.textMuted)),
              ],
            );
          }).toList(),
        ),
        const SizedBox(height: 32),
      ],
    );
  }
}
