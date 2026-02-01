import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/app_atomic_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/atoms/visuals/fg_background.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppAtomicCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildAppAtomicCardPlayground(BuildContext context) {
  return FgBackground(
    child: Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SizedBox(
          height: 600,
          width: 350,
          child: AppAtomicCard(
            title: context.knobs
                .string(label: 'Title', initialValue: 'Atomic Core'),
            category: context.knobs
                .string(label: 'Category', initialValue: 'Foundation'),
            imageUrl: context.knobs.string(
              label: 'Image URL',
              initialValue:
                  'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?q=80&w=1000&auto=format&fit=crop',
            ),
            level: context.knobs.string(label: 'Level', initialValue: 'Yellow'),
            bodyPart: context.knobs
                .string(label: 'Focus', initialValue: 'Abdominals'),
            intensity: context.knobs
                .string(label: 'Intensity', initialValue: 'Medium'),
            onTap: () {},
          ),
        ),
      ),
    ),
  );
}
