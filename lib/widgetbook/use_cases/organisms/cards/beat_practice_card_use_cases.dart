import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/organisms/cards/beat_practice_card.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: BeatPracticeCard,
  path: 'Design System/Organisms/Cards',
)
Widget buildBeatPracticeCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 560,
          width: 340,
          child: BeatPracticeCard(
            title: 'BEAT',
            subtitle: 'PRACTICE',
            rhythm: 'Syncopated 8ths',
            bpm: 112,
            currentStreak: 12,
            onTap: () {},
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'High BPM',
  type: BeatPracticeCard,
  path: '[Organisms]/Cards',
)
Widget buildBeatPracticeCardHighBpm(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 560,
          width: 340,
          child: BeatPracticeCard(
            title: 'TEMPO',
            subtitle: 'CHALLENGE',
            rhythm: 'Double Time',
            bpm: 140,
            currentStreak: 25,
            onTap: () {},
            onFlip: () {},
          ),
        ),
      ),
    ),
  );
}
