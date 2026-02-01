import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/app_mini_interactive_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppMiniInteractiveCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildAppMiniInteractiveCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 300,
          width: 200,
          child: AppMiniInteractiveCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Groove Basics'),
            subtitle: context.knobs
                .string(label: 'Subtitle', initialValue: 'Lesson 1'),
            level: context.knobs.string(label: 'Level', initialValue: 'White'),
            style:
                context.knobs.string(label: 'Style', initialValue: 'Hip Hop'),
            difficulty: context.knobs
                .string(label: 'Difficulty', initialValue: 'Beginner'),
            backgroundImage: context.knobs.string(
              label: 'Background Image URL',
              initialValue:
                  'https://images.unsplash.com/photo-1547153760-18fc86324498?q=80&w=1000&auto=format&fit=crop',
            ),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
