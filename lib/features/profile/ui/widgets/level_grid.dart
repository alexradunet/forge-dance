import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_sizes.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../model/level_model.dart';
import 'level_item.dart';

class LevelGrid extends StatelessWidget {
  final List<DanceLevel> levels;
  final Function(DanceLevel) onLevelTap;

  const LevelGrid({
    super.key,
    required this.levels,
    required this.onLevelTap,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(AppSpacing.xxl),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: AppSizes.squareTileLg,
        crossAxisSpacing: AppSpacing.lg,
        mainAxisSpacing: AppSpacing.lg,
      ),
      itemCount: levels.length,
      itemBuilder: (context, index) {
        final level = levels[index];
        return LevelItem(
          level: level,
          onTap: () => onLevelTap(level),
        );
      },
    );
  }
}
