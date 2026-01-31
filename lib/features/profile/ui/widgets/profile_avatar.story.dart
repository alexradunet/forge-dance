import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/features/profile/ui/widgets/profile_avatar.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ProfileAvatar,
  path: 'Design System/Atoms/Avatar',
)
Widget buildProfileAvatarDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: const Center(
      child: ProfileAvatar(
        radius: 64,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Badge (Legend)',
  type: ProfileAvatar,
  path: '[Atoms]/Avatar',
)
Widget buildProfileAvatarWithBadge(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: const Center(
      child: ProfileAvatar(
        radius: 64,
        levelBadge: 'LEGEND',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Badge (Pro)',
  type: ProfileAvatar,
  path: '[Atoms]/Avatar',
)
Widget buildProfileAvatarWithProBadge(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: const Center(
      child: ProfileAvatar(
        radius: 64,
        levelBadge: 'PRO',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small',
  type: ProfileAvatar,
  path: '[Atoms]/Avatar',
)
Widget buildProfileAvatarSmall(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: const Center(
      child: ProfileAvatar(
        radius: 32,
        levelBadge: 'LVL 42',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Large',
  type: ProfileAvatar,
  path: '[Atoms]/Avatar',
)
Widget buildProfileAvatarLarge(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: const Center(
      child: ProfileAvatar(
        radius: 96,
        levelBadge: 'MASTER',
      ),
    ),
  );
}
