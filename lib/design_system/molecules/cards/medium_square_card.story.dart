import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/medium_square_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Medium Square Card',
  type: MediumSquareCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildMediumSquareCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 200,
          child: MediumSquareCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Toprock Style'),
            subtitle: context.knobs.string(
                label: 'Subtitle', initialValue: 'Discover your flavor'),
            badgeText:
                context.knobs.string(label: 'Badge', initialValue: 'STYLE'),
            badgeColor: context.knobs
                .color(label: 'Badge Color', initialValue: AppColors.forgeFire),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
