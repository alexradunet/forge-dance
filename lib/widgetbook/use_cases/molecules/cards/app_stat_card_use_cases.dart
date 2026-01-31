import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/molecules/cards/app_stat_card.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: AppStatCard,
  path: 'Design System/Molecules/AppStatCard',
)
Widget buildAppStatCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          AppStatCard(
            label: 'Streak',
            value: '12',
            icon: Icons.local_fire_department,
          ),
          SizedBox(width: 16),
          AppStatCard(
            label: 'Level',
            value: '24',
            icon: Icons.workspace_premium,
            iconColor: AppColors.legendGold,
          ),
        ],
      ),
    ),
  );
}
