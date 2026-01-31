import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/feedback/toast_notification.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: ToastNotification,
  path: 'Design System/Molecules',
)
Widget buildToastNotificationPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ToastNotification(
          title: context.knobs
              .string(label: 'Title', initialValue: 'Notification Title'),
          message: context.knobs.string(
            label: 'Message',
            initialValue:
                'This is a description message for the toast notification.',
          ),
          type: context.knobs.list(
            label: 'Type',
            options: ToastType.values,
            initialOption: ToastType.success,
          ),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: ToastNotification,
  path: 'Design System/Molecules',
)
Widget buildToastNotificationShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const ToastNotification(
              title: 'Success',
              message: 'Your changes have been saved successfully.',
              type: ToastType.success,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Error',
              message: 'Failed to connect to the server. Please try again.',
              type: ToastType.error,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Info',
              message: 'A new update is available for download.',
              type: ToastType.info,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Warning',
              message: 'Your subscription is about to expire.',
              type: ToastType.warning,
            ),
          ],
        ),
      ),
    ),
  );
}
