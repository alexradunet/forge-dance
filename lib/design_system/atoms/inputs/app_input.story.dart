import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/atoms/inputs/app_input.dart';
import 'package:flutter_mvvm_riverpod/design_system/tokens/app_colors.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: AppInput,
  path: 'Design System/Atoms/AppInput',
)
Widget buildAppInputPlayground(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: AppInput(
          label: context.knobs.string(label: 'Label', initialValue: 'Email'),
          hintText: context.knobs
              .string(label: 'Hint', initialValue: 'Enter your email'),
          errorText:
              context.knobs.boolean(label: 'Show Error', initialValue: false)
                  ? 'Invalid email address'
                  : null,
          isEnabled:
              context.knobs.boolean(label: 'Is Enabled', initialValue: true),
          obscureText:
              context.knobs.boolean(label: 'Obscure Text', initialValue: false),
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'States',
  type: AppInput,
  path: 'Design System/Atoms/AppInput',
)
Widget buildAppInputStates(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: const [
          AppInput(
            label: 'Default',
            hintText: 'Type something...',
          ),
          SizedBox(height: 24),
          AppInput(
            label: 'With Prefix Icon',
            hintText: 'Search...',
            prefixIcon: Icon(Icons.search, color: AppColors.textMuted),
          ),
          SizedBox(height: 24),
          AppInput(
            label: 'With Error',
            hintText: 'Wrong input',
            errorText: 'This field is required',
          ),
          SizedBox(height: 24),
          AppInput(
            label: 'Disabled',
            hintText: 'Cannot type here',
            isEnabled: false,
          ),
        ],
      ),
    ),
  );
}
