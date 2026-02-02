import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/molecules/cards/fg_interactive_card_thumbnail.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgInteractiveCardThumbnail,
  path: 'Design System/Molecules/Cards',
)
Widget buildFgInteractiveCardThumbnailPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 200,
          width: 150,
          child: FgInteractiveCardThumbnail(
            title: context.knobs.string(
              label: 'Title',
              initialValue: 'Basic Bounce',
            ),
            subtitle: context.knobs.string(
              label: 'Subtitle',
              initialValue: 'Lesson 1',
            ),
            backgroundImage: context.knobs.string(
              label: 'Background Image URL',
              initialValue:
                  'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?q=80&w=1000&auto=format&fit=crop',
            ),
            level: context.knobs.string(
              label: 'Level',
              initialValue: 'Beginner',
            ),
            backTitle: context.knobs.string(
              label: 'Back Title',
              initialValue: 'Details',
            ),
            backSubtitle: context.knobs.string(
              label: 'Back Subtitle',
              initialValue: 'More Info',
            ),
            onTap: (_) {},
          ),
        ),
      ),
    ),
  );
}
