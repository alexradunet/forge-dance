import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Card',
  type: SkeletonLoader,
  path: 'Design System/Atoms/Skeletons',
)
Widget buildSkeletonLoaderCard(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SkeletonLoader.card(),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Avatar',
  type: SkeletonLoader,
  path: 'Design System/Atoms/Skeletons',
)
Widget buildSkeletonLoaderAvatar(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: SkeletonLoader.avatar(),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Text',
  type: SkeletonLoader,
  path: 'Design System/Atoms/Skeletons',
)
Widget buildSkeletonLoaderText(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SkeletonLoader.text(),
      ),
    ),
  );
}
