import 'package:flutter/material.dart';
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
      padding: const EdgeInsets.all(24),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
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
