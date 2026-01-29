import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/collectible_movement_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: CollectibleMovementCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildCollectibleMovementCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 500,
          width: 340,
          child: CollectibleMovementCard(
            title: 'WINDMILL',
            category: 'Power Move',
            rhythm: 'Continuous',
            bpm: 98,
            tags: const ['Power', 'Intermediate'],
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Footwork',
  type: CollectibleMovementCard,
  path: '[Organisms]/Cards',
)
Widget buildCollectibleMovementCardFootwork(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 500,
          width: 340,
          child: CollectibleMovementCard(
            title: '6-STEP',
            category: 'Footwork',
            rhythm: 'Syncopated',
            bpm: 102,
            tags: const ['Footwork', 'Foundation'],
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}
