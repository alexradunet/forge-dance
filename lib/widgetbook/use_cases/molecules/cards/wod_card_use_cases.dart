import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: WODCard,
  path: 'Design System/Molecules/Cards',
)
Widget buildWODCardDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SizedBox(
          height: 400,
          child: WODCard(
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
