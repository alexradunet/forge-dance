import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../design_system/organisms/workouts/featured_workout_card.dart';
import '../../../design_system/tokens/app_colors.dart';

// TODO: Fix type resolution issue with widgetbook_generator
// @widgetbook.UseCase(
//   name: 'Default',
//   type: FeaturedWorkoutCard,
//   path: 'Design System/Organisms',
// )
Widget buildFeaturedWorkoutCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 400,
          child: FeaturedWorkoutCard(
            title: 'Fire Starter',
            subtitle: 'INTENSE',
            level: 3,
            duration: '30 min',
            onStart: () {},
          ),
        ),
      ),
    ),
  );
}
