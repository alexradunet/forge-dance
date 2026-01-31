import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/tall_feature_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Tall Feature Card',
  type: TallFeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildTallFeatureCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 300,
          child: TallFeatureCard(
            name: context.knobs
                .string(label: 'Name', initialValue: 'Ronnie Abaldonado'),
            nickname:
                context.knobs.string(label: 'Nickname', initialValue: 'Ronnie'),
            tagline: context.knobs.string(
                label: 'Tagline',
                initialValue: 'One of the most decorated B-Boys in history.'),
            accentColor: context.knobs.color(
                label: 'Accent Color', initialValue: AppColors.mysticPurple),
            stats: const [
              TallFeatureCardStat(value: '19', label: 'TITLES'),
              TallFeatureCardStat(value: '15', label: 'YEARS'),
            ],
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
