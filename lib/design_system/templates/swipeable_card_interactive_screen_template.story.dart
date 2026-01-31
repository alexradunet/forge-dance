import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';
import 'package:flutter_mvvm_riverpod/design_system/templates/swipeable_card_interactive_screen_template.dart';
import 'package:flutter_mvvm_riverpod/design_system/templates/interactive_card_template.dart';

@widgetbook.UseCase(
  name: 'Swipeable Deck',
  type: SwipeableCardInteractiveScreenTemplate,
  path: 'Design System/Templates',
)
Widget buildSwipeableCardInteractiveScreen(BuildContext context) {
  return SwipeableCardInteractiveScreenTemplate(
    title: context.knobs.string(label: 'Title', initialValue: 'THEORY'),
    subtitle: context.knobs
        .string(label: 'Subtitle', initialValue: 'Hip Hop Foundations'),
    showProgress:
        context.knobs.boolean(label: 'Show Progress', initialValue: true),
    onBack: () {},
    onMenu: () {},
    cards: [
      // Card 1: Bounce
      InteractiveCardTemplate(
        frontContent: _buildSimpleCardContent(
          'The Bounce',
          'Fundamental Groove',
          'The "Bounce" is the core rhythmic movement.',
        ),
        backContent: _buildSimpleBackContent(
            'Keep your knees loose and find the pocket of the beat.'),
      ),

      // Card 2: Rock
      InteractiveCardTemplate(
        accentColor: AppColors.breakingBlue,
        frontContent: _buildSimpleCardContent(
          'The Rock',
          'Weight Shift',
          'Rocking adds direction to the bounce.',
        ),
        backContent: _buildSimpleBackContent(
            'Lean forward and back, syncing with the snare.'),
      ),

      // Card 3: Roll
      InteractiveCardTemplate(
        accentColor: AppColors.mysticPurple,
        frontContent: _buildSimpleCardContent(
          'The Roll',
          'Circular Flow',
          'Body rolls connect movements smoothly.',
        ),
        backContent: _buildSimpleBackContent(
            'Isolate your spine - head, shoulders, chest, hips.'),
      ),
    ],
    bottomAction: FgButton(
      text: 'Mark Complete',
      variant: FgButtonVariant.primary,
      onPressed: () {},
    ),
  );
}

Widget _buildSimpleCardContent(String title, String subtitle, String body) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: AppTypography.h1.copyWith(
              color: AppColors.crystalWhite,
              fontSize: 32,
              letterSpacing: 2,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: AppTypography.body.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Text(
            body,
            style: AppTypography.body.copyWith(color: AppColors.textMain),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}

Widget _buildSimpleBackContent(String tip) {
  return Center(
    child: Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.lightbulb_outline,
              color: AppColors.forgeFire, size: 48),
          const SizedBox(height: 16),
          Text(
            'PRO TIP',
            style: AppTypography.label.copyWith(
              color: AppColors.forgeFire,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            tip,
            style: AppTypography.h3.copyWith(color: AppColors.crystalWhite),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    ),
  );
}
