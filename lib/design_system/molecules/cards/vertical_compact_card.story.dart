import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/vertical_compact_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Vertical Compact Card',
  type: VerticalCompactCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildVerticalCompactCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 150,
          child: VerticalCompactCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Windmill Prep'),
            badgeText:
                context.knobs.string(label: 'Badge', initialValue: 'DRILL'),
            badgeColor: context.knobs.color(
                label: 'Badge Color', initialValue: AppColors.breakingBlue),
            duration:
                context.knobs.string(label: 'Duration', initialValue: '5 min'),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
