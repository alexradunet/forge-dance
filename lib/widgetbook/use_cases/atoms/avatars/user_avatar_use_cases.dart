import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Large',
  type: UserAvatar,
  path: 'Design System/Atoms/Avatars',
)
Widget buildUserAvatarLarge(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: UserAvatar.large(
        initials: 'JD',
        level: 5,
        isOnline: true,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Medium',
  type: UserAvatar,
  path: 'Design System/Atoms/Avatars',
)
Widget buildUserAvatarMedium(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: UserAvatar.medium(
        initials: 'AB',
        level: 3,
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Small',
  type: UserAvatar,
  path: 'Design System/Atoms/Avatars',
)
Widget buildUserAvatarSmall(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: UserAvatar.small(
        initials: 'CD',
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Notifications',
  type: UserAvatar,
  path: 'Design System/Atoms/Avatars',
)
Widget buildUserAvatarWithNotifications(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: UserAvatar.medium(
        initials: 'EF',
        notificationCount: 3,
      ),
    ),
  );
}
