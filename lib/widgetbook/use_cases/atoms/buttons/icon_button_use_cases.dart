import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Filled',
  type: IconButtonAtom,
  path: 'Design System/Atoms/Buttons',
)
Widget buildIconButtonFilled(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: IconButtonAtom.filled(
        icon: Icons.play_arrow,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Outlined',
  type: IconButtonAtom,
  path: 'Design System/Atoms/Buttons',
)
Widget buildIconButtonOutlined(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: IconButtonAtom.outlined(
        icon: Icons.favorite,
        onPressed: () {},
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Ghost',
  type: IconButtonAtom,
  path: 'Design System/Atoms/Buttons',
)
Widget buildIconButtonGhost(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: IconButtonAtom.ghost(
        icon: Icons.share,
        onPressed: () {},
      ),
    ),
  );
}
