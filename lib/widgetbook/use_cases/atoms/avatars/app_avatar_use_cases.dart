import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/atoms/avatars/app_avatar.dart';
import '../../../../design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppAvatar,
  path: 'Design System/Atoms/AppAvatar',
)
Widget buildAppAvatarPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppAvatar(
        imageUrl: context.knobs.string(
          label: 'Image URL',
          initialValue:
              'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=100&auto=format&fit=crop',
        ),
        fallbackText:
            context.knobs.string(label: 'Fallback Text', initialValue: 'JD'),
        size: context.knobs.double
            .slider(label: 'Size', initialValue: 40, min: 20, max: 200),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Fallback State',
  type: AppAvatar,
  path: 'Design System/Atoms/AppAvatar',
)
Widget buildAppAvatarFallback(BuildContext context) {
  return const Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: AppAvatar(
        fallbackText: 'AR',
        size: 60,
      ),
    ),
  );
}
