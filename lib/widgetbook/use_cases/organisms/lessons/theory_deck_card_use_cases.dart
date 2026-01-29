import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Beat Tap Exercise',
  type: TheoryDeckCard,
  path: 'Design System/Organisms/Lessons',
)
Widget buildTheoryDeckCardBeatTap(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TheoryDeckCard(
          title: 'Beat Practice',
          subtitle: 'Tap the syncopation',
          moduleLabel: 'Module 3',
          moduleName: 'Rhythm & Timing',
          currentStep: 3,
          totalSteps: 5,
          heroContent: BeatTapZone(
            bpm: 100,
            streak: 12,
            onTap: () {},
          ),
          bottomContent: const ExerciseInfoBar(
            title: 'Syncopated 8ths',
            subtitle: 'Rhythm Pattern: Focus on off-beats',
            icon: Icons.graphic_eq,
          ),
          onFlip: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Minimal',
  type: TheoryDeckCard,
  path: 'Design System/Organisms/Lessons',
)
Widget buildTheoryDeckCardMinimal(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TheoryDeckCard(
          title: 'The Water Element',
          subtitle: 'Move as if you are underwater',
          moduleLabel: 'Experiment',
          moduleName: 'Creative Lab',
          currentStep: 4,
          totalSteps: 5,
          accentColor: AppColors.mysticPurple,
          bottomContent: const ExerciseInfoBar(
            title: 'Free-Flow Exercise',
            subtitle: 'Focus on resistance and fluidity',
            icon: Icons.water_drop,
            iconColor: AppColors.breakingBlue,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Beat Tap Zone',
  type: BeatTapZone,
  path: 'Design System/Organisms/Lessons',
)
Widget buildBeatTapZone(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: BeatTapZone(
        bpm: 120,
        streak: 5,
        onTap: () {},
      ),
    ),
  );
}
