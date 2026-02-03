import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;
import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgLabel,
  path: 'Design System/Atoms/Typography',
)
Widget buildFgLabelPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: FgLabel(
        text:
            context.knobs.string(label: 'Text', initialValue: 'Email Address'),
        isRequired:
            context.knobs.boolean(label: 'Required', initialValue: false),
        icon: context.knobs.listOrNull(
          label: 'Icon',
          options: [Icons.email, Icons.person, Icons.lock],
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Showcase',
  type: FgLabel,
  path: 'Design System/Atoms/Typography',
)
Widget buildFgLabelShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          FgLabel(text: 'Username', isRequired: true),
          SizedBox(height: 16),
          FgLabel(text: 'Optional Bio'),
          SizedBox(height: 16),
          FgLabel(text: 'Security Settings', icon: Icons.security),
        ],
      ),
    ),
  );
}
