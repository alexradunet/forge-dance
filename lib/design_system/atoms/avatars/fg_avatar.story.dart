import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Large',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarLarge(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgAvatar.large(
        initials: 'JD',
        level: 5,
        isOnline: true,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Medium',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarMedium(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgAvatar.medium(
        initials: 'AB',
        level: 3,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarSmall(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgAvatar.small(
        initials: 'CD',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Notifications',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarWithNotifications(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgAvatar.medium(
        initials: 'EF',
        notificationCount: 3,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Loading State',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarLoading(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FgAvatar(isLoading: true, size: 40),
          SizedBox(width: 16),
          FgAvatar(isLoading: true, size: 56),
          SizedBox(width: 16),
          FgAvatar(isLoading: true, size: 80),
        ],
      ),
    ),
  );
}
