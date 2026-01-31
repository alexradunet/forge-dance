import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/portrait_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Portrait Card',
  type: PortraitCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildPortraitCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: 200,
          child: PortraitCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Live Workshop'),
            subtitle: context.knobs
                .string(label: 'Subtitle', initialValue: 'With B-Boy Thesis'),
            badgeText:
                context.knobs.string(label: 'Badge', initialValue: 'LIVE'),
            participantCount: context.knobs
                .string(label: 'Participants', initialValue: '1.2k'),
            actionLabel:
                context.knobs.string(label: 'Action', initialValue: 'JOIN NOW'),
            actionIcon: Icons.login,
            onAction: () {},
          ),
        ),
      ),
    ),
  );
}
