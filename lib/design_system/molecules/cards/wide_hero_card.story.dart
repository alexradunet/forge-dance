import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/wide_hero_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Wide Hero Card',
  type: WideHeroCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildWideHeroCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: WideHeroCard(
          title: context.knobs
              .string(label: 'Title', initialValue: 'The Art of Battle'),
          badgeText:
              context.knobs.string(label: 'Badge', initialValue: 'DOCUMENTARY'),
          viewCount:
              context.knobs.string(label: 'Views', initialValue: '5.4k views'),
          onTap: () {},
        ),
      ),
    ),
  );
}
