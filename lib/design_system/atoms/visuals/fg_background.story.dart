import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_typography.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgBackground,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgBackgroundPlayground(BuildContext context) {
  return FgBackground(
    showGrid: context.knobs.boolean(label: 'Show Grid', initialValue: true),
    showGradients:
        context.knobs.boolean(label: 'Show Gradients', initialValue: true),
    child: Center(
      child: Text(
        'Content Overlay',
        style: AppTypography.h3.copyWith(color: AppColors.crystalWhite),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgBackground,
  path: 'Design System/Atoms/Visuals',
)
Widget buildFgBackgroundShowcase(BuildContext context) {
  return const FgBackground(
    showGrid: true,
    showGradients: true,
    child: Center(
      child: Text(
        'Standard Background',
        style: TextStyle(color: Colors.white),
      ),
    ),
  );
}
