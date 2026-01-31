import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/inputs/app_input.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: AppInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildAppInputDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppInput(
          label: context.knobs
              .string(label: 'Label', initialValue: 'Email Address'),
          placeholder: context.knobs
              .string(label: 'Placeholder', initialValue: 'Enter your email'),
          prefixIcon: Icons.email_outlined,
          errorText: context.knobs.stringOrNull(label: 'Error Text'),
          helperText: context.knobs.stringOrNull(label: 'Helper Text'),
          isEnabled:
              context.knobs.boolean(label: 'Enabled', initialValue: true),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Password',
  type: AppInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildAppInputPassword(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppInput.password(
          label: 'Password',
          placeholder: 'Enter your password',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Search',
  type: AppInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildAppInputSearch(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppInput.search(
          placeholder: 'Search for lessons...',
          controller: controller,
          showFilter: true,
          onFilterPressed: () {},
          onClear: () {},
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Multiline',
  type: AppInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildAppInputMultiline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppInput.multiline(
          label: 'Feedback',
          placeholder: 'Tell us what you think...',
        ),
      ),
    ),
  );
}
