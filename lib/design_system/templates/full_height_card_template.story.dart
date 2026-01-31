import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/templates/full_height_card_template.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Full Height Card Template',
  type: FullHeightCardTemplate,
  path: 'Design System/Templates',
)
Widget buildFullHeightCardTemplate(BuildContext context) {
  return FullHeightCardTemplate(
    backgroundColor: context.knobs
        .color(label: 'Background Color', initialValue: AppColors.gray950),
    child: Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
        ),
        child:
            const Text('Card Content', style: TextStyle(color: Colors.white)),
      ),
    ),
  );
}
