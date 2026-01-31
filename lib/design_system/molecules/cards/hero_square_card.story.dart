import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/hero_square_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Hero Square Card',
  type: HeroSquareCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildHeroSquareCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 350,
          child: HeroSquareCard(
            title: context.knobs.string(label: 'Title', initialValue: 'POWER'),
            titleSecondLine: context.knobs
                .string(label: 'Title Second Line', initialValue: 'MOVES'),
            badgeText: context.knobs
                .string(label: 'Badge Text', initialValue: 'ADVANCED'),
            seriesLabel: context.knobs
                .string(label: 'Series Label', initialValue: 'SERIES 1'),
            actionLabel: context.knobs
                .string(label: 'Action Label', initialValue: 'START CHALLENGE'),
            actionIcon: Icons.play_arrow,
            premiumLabel:
                context.knobs.boolean(label: 'Show Premium', initialValue: true)
                    ? 'PRO'
                    : null,
            infoItems: const [
              HeroSquareCardInfo(icon: Icons.timer, text: '45 MIN'),
              HeroSquareCardInfo(
                  icon: Icons.local_fire_department, text: 'HIGH INTENSITY'),
            ],
            onAction: () {},
          ),
        ),
      ),
    ),
  );
}
