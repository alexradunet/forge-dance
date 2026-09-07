import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../../../design_system/molecules/cards/fg_session_card.dart';
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
  Widget build(BuildContext context) {
    final colors = Theme.of(context).forgeColors;
    return Scaffold(
      body: FgBackground(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    AppHeader(
                      title: LocaleKeys.dailyPractice.tr(),
                      subtitle: LocaleKeys.workoutOverview.tr(),
                      onBack: onClose,
                    ),
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 720),
                        child: Padding(
                          padding: AppSpacing.screen,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              FgSessionCard(
                                title: workout.title,
                                subtitle:
                                    '${workout.style} • ${workout.difficulty}',
                                imageUrl: workout.imageUrl,
                                imageAspectRatio: 16 / 9,
                                label: LocaleKeys.minutesCount.tr(
                                  args: ['${workout.estimatedMinutes}'],
                                ),
                                action: Text(
                                  workout.description,
                                  style: AppTypography.bodyLarge.copyWith(
                                    color: colors.onImmersiveMuted,
                                  ),
                                ),
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                              Wrap(
                                spacing: AppSpacing.md,
                                runSpacing: AppSpacing.sm,
                                children: [
                                  FgBadge(
                                    text: LocaleKeys.exercisesCount.tr(
                                      args: ['${workout.exercises.length}'],
                                    ),
                                  ),
                                  FgBadge(
                                    text: LocaleKeys.xpReward.tr(
                                      args: ['${workout.xp}'],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: AppSpacing.xxl),
                              for (
                                var index = 0;
                                index < workout.exercises.length;
                                index++
                              ) ...[
                                FgCard(
                                  immersive: true,
                                  child: Row(
                                    children: [
                                      FgBadge(text: '${index + 1}'),
                                      const SizedBox(width: AppSpacing.lg),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              workout.exercises[index].name,
                                              style: AppTypography.bodyLarge
                                                  .copyWith(
                                                    color: colors.onImmersive,
                                                  ),
                                            ),
                                            const SizedBox(
                                              height: AppSpacing.xs,
                                            ),
                                            Text(
                                              LocaleKeys.secondsCount.tr(
                                                args: [
                                                  '${workout.exercises[index].seconds}',
                                                ],
                                              ),
                                              style: AppTypography.bodySmall
                                                  .copyWith(
                                                    color:
                                                        colors.onImmersiveMuted,
                                                  ),
                                            ),
                                          ],
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
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SafeArea(
              top: false,
              minimum: AppSpacing.screen,
              child: SizedBox(
                width: 720,
                child: FgButton(
                  text: LocaleKeys.startWorkoutSemantic.tr(),
                  icon: const Icon(Icons.play_arrow_rounded),
                  semanticLabel: LocaleKeys.startWorkoutSemantic.tr(),
                  onPressed: onStart,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
