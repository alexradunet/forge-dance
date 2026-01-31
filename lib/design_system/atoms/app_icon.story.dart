import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/atoms/app_icon.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'App Icon',
  type: AppIcon,
  path: 'Design System/Atoms',
)
Widget buildAppIcon(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AppIcon(
            icon: Icons.home,
            size: context.knobs.double
                .slider(label: 'Size', initialValue: 24, min: 16, max: 64),
            color: context.knobs
                .color(label: 'Color', initialValue: AppColors.crystalWhite),
          ),
          const SizedBox(height: 16),
          AppIcon(
            icon: Icons.star,
            size: context.knobs.double
                .slider(label: 'Size', initialValue: 24, min: 16, max: 64),
            color: context.knobs
                .color(label: 'Color', initialValue: AppColors.forgeFire),
          ),
        ],
      ),
    ),
  );
}
