import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/feature_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFeatureCardPlayground(BuildContext context) {
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

@widgetbook.UseCase(
  name: 'Showcase',
  type: FeatureCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFeatureCardShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            FeatureCard(
              title: 'Introduction to Rhythm',
              subtitle: 'Feel the beat',
              categoryLabel: 'Musicality',
              accentColor: AppColors.forgeFire,
              onTap: () {},
            ),
            const SizedBox(height: 16),
            FeatureCard(
              title: 'Advanced Spins',
              subtitle: 'Control and balance',
              categoryLabel: 'Technique',
              accentColor: AppColors.breakingBlue,
              onTap: () {},
            ),
          ],
        ),
      ),
    ),
  );
}
