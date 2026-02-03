import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/fg_interactive_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgInteractiveCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildFgInteractiveCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 600,
          width: 350,
          child: FgInteractiveCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Rhythm Flow'),
            subtitle: context.knobs
                .string(label: 'Subtitle', initialValue: 'Lesson 1'),
            backgroundImage: context.knobs.string(
              label: 'Background Image URL',
              initialValue:
                  'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=1000&auto=format&fit=crop',
            ),
            level: context.knobs.string(label: 'Level', initialValue: 'Blue'),
            style: context.knobs.string(label: 'Style', initialValue: 'Urban'),
            difficulty: context.knobs
                .string(label: 'Difficulty', initialValue: 'Advanced'),
            progress: context.knobs.double
                .slider(label: 'Progress', initialValue: 0.4, min: 0, max: 1),
            isPlaying:
                context.knobs.boolean(label: 'Is Playing', initialValue: false),
            isFavorited: context.knobs
                .boolean(label: 'Is Favorited', initialValue: true),
            onTap: () {},
            onPlayTap: () {},
            onToggleFavorite: () {},
          ),
        ),
      ),
    ),
  );
}
