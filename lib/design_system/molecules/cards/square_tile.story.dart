import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/square_tile.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Square Tile',
  type: SquareTile,
  path: 'Design System/Molecules/Cards',
)
Widget buildSquareTile(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SquareTile(
          label: context.knobs.string(label: 'Label', initialValue: 'Music'),
          icon: Icons.music_note,
          accentColor: context.knobs.color(
              label: 'Accent Color', initialValue: AppColors.electricBlue),
          size: context.knobs.double
              .slider(label: 'Size', initialValue: 112, min: 80, max: 150),
          onTap: () {},
        ),
      ),
    ),
  );
}
