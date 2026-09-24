import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../model/workout.dart';

/// A preview, not a player step: browsing never starts the countdown.
class WorkoutOverview extends StatelessWidget {
  const WorkoutOverview({
    super.key,
    required this.workout,
    required this.onStart,
    required this.onClose,
  });
  final Workout workout;
  final VoidCallback onStart;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    title: LocaleKeys.workoutOverview.tr(),
    onBack: onClose,
    bodyBuilder: (context) => FgReadingBody(
      child: ListView(
        padding: AppSpacing.allLG,
        children: [
          FgSectionHeading(
            eyebrow: LocaleKeys.dailyPractice.tr(),
            title: workout.title,
            subtitle: '${workout.style} • ${workout.difficulty}',
          ),
          const SizedBox(height: AppSpacing.lg),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.sm,
            children: [
              FgBadge(
                text: LocaleKeys.minutesCount.tr(
                  args: ['${workout.estimatedMinutes}'],
                ),
              ),
              FgBadge(
                text: LocaleKeys.exercisesCount.tr(
                  args: ['${workout.exercises.length}'],
                ),
              ),
              FgBadge(text: LocaleKeys.xpReward.tr(args: ['${workout.xp}'])),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(workout.description),
          const SizedBox(height: AppSpacing.lg),
          FgButton(
            text: LocaleKeys.startWorkoutSemantic.tr(),
            icon: const Icon(Icons.play_arrow_rounded),
            semanticLabel: LocaleKeys.startWorkoutSemantic.tr(),
            onPressed: onStart,
          ),
          const SizedBox(height: AppSpacing.xxl),
          for (var index = 0; index < workout.exercises.length; index++) ...[
            FgRoundPanel(
              label: '${index + 1}',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    workout.exercises[index].name,
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    LocaleKeys.secondsCount.tr(
                      args: ['${workout.exercises[index].seconds}'],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
          ],
        ],
      ),
    ),
  );
}
