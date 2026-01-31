import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:widgetbook/widgetbook.dart';

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: FgAvatar(
        imageUrl: context.knobs.stringOrNull(label: 'Image URL'),
        initials: context.knobs.string(label: 'Initials', initialValue: 'JD'),
        level: context.knobs.intOrNull.slider(
          label: 'Level',
          min: 1,
          max: 99,
          initialValue: 5,
        ),
        isOnline: context.knobs.boolean(label: 'Is Online', initialValue: true),
        notificationCount: context.knobs.intOrNull.slider(
          label: 'Notifications',
          min: 0,
          max: 20,
          initialValue: 3,
        ),
        size: context.knobs.double.slider(
          label: 'Size',
          min: 24,
          max: 120,
          initialValue: 56,
        ),
        isLoading:
            context.knobs.boolean(label: 'Is Loading', initialValue: false),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgAvatar,
  path: 'Design System/Atoms',
)
Widget buildFgAvatarShowcase(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.gray950,
    body: SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Center(
        child: Column(
          children: [
            _AvatarSection(title: 'Sizes'),
            SizedBox(height: 40),
            _AvatarSection(title: 'Status & Badges', showStatus: true),
            SizedBox(height: 40),
            _AvatarSection(title: 'Loading States', isLoading: true),
          ],
        ),
      ),
    ),
  );
}

class _AvatarSection extends StatelessWidget {
  final String title;
  final bool showStatus;
  final bool isLoading;

  const _AvatarSection({
    required this.title,
    this.showStatus = false,
    this.isLoading = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(title,
            style: AppTypography.h5.copyWith(color: AppColors.crystalWhite)),
        const SizedBox(height: 24),
        Wrap(
          spacing: 24,
          runSpacing: 24,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            if (isLoading) ...[
              const FgAvatar.small(isLoading: true),
              const FgAvatar.medium(isLoading: true),
              const FgAvatar.large(isLoading: true),
            ] else if (showStatus) ...[
              const FgAvatar.medium(initials: 'ON', isOnline: true),
              const FgAvatar.medium(initials: 'LV', level: 42),
              const FgAvatar.medium(initials: 'NT', notificationCount: 7),
              const FgAvatar.medium(
                initials: 'ALL',
                isOnline: true,
                level: 99,
                notificationCount: 12,
              ),
            ] else ...[
              const FgAvatar.small(initials: 'SM'),
              const FgAvatar.medium(initials: 'MD'),
              const FgAvatar.large(initials: 'LG'),
            ],
          ],
        ),
      ],
    );
  }
}
