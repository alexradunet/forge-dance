import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/inputs/fg_input.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgInput(
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
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputPassword(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgInput.password(
          label: 'Password',
          placeholder: 'Enter your password',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Search',
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputSearch(BuildContext context) {
  final controller = TextEditingController();

  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgInput.search(
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
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputMultiline(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: FgInput.multiline(
          label: 'Feedback',
          placeholder: 'Tell us what you think...',
        ),
      ),
    ),
  );
}
