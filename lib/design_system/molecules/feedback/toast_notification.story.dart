import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/molecules/feedback/toast_notification.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Toast Notification',
  type: ToastNotification,
  path: 'Design System/Molecules/Feedback',
)
Widget buildToastNotification(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ToastNotification(
              title: context.knobs
                  .string(label: 'Success Title', initialValue: 'Success!'),
              message: context.knobs.string(
                  label: 'Success Message',
                  initialValue: 'Operation completed successfully.'),
              type: ToastType.success,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Error',
              message: 'Something went wrong.',
              type: ToastType.error,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Info',
              message: 'Here is some information.',
              type: ToastType.info,
            ),
            const SizedBox(height: 16),
            const ToastNotification(
              title: 'Warning',
              message: 'Proceed with caution.',
              type: ToastType.warning,
            ),
          ],
        ),
      ),
    ),
  );
}
