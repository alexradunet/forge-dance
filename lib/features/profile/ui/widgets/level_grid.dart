import 'package:flutter/material.dart';

import '../../../../design_system/design_system.dart';
import '../../model/level_model.dart';
import 'level_item.dart';

class LevelGrid extends StatelessWidget {
  final List<DanceLevel> levels;
  final Function(DanceLevel) onLevelTap;

  const LevelGrid({super.key, required this.levels, required this.onLevelTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: AppSpacing.allXXL,
      child: FgProgramCardLayout(
        children: [
          for (final level in levels)
            LevelItem(level: level, onTap: () => onLevelTap(level)),
        ],
      ),
    );
  }
}
