import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/feature_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Feature Card',
  type: FeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFeatureCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: FeatureCard(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Footwork Fundamentals'),
          subtitle: context.knobs.string(
              label: 'Subtitle',
              initialValue: 'Master the basics of footwork.'),
          categoryLabel: context.knobs
              .string(label: 'Category', initialValue: 'Technique'),
          accentColor: context.knobs.color(
              label: 'Accent Color', initialValue: AppColors.mysticPurple),
          onTap: () {},
        ),
      ),
    ),
  );
}
