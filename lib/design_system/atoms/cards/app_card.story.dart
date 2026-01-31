import 'package:flutter/material.dart';

import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';

import 'package:flutter_mvvm_riverpod/design_system/atoms/cards/app_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppCard,
  path: 'Design System/Atoms/AppCard',
)
Widget buildAppCardPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppCard(
          hasGlow:
              context.knobs.boolean(label: 'Has Glow', initialValue: false),
          onTap:
              context.knobs.boolean(label: 'Is Tappable', initialValue: false)
                  ? () {}
                  : null,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppCardHeader(
                title: Text(context.knobs
                    .string(label: 'Title', initialValue: 'Card Title')),
                subtitle: Text(context.knobs.string(
                    label: 'Subtitle',
                    initialValue: 'This is a description of the card.')),
              ),
              const AppCardContent(
                child: Text(
                  'Main content area of the card where you can place any widget.',
                  style: TextStyle(color: AppColors.textMain),
                ),
              ),
              AppCardFooter(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () {}, child: const Text('Action')),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading State',
  type: AppCard,
  path: 'Design System/Atoms/AppCard',
)
Widget buildAppCardLoading(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppCard(
          isLoading: true,
          child: Container(
              height:
                  100), // Child should be ignored or hidden by isLoading logic
        ),
      ),
    ),
  );
}
