import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';
import '../../../../theme/app_colors.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: PasswordInputAtom,
  path: 'Design System/Atoms/Inputs',
)
Widget buildPasswordInputAtomDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PasswordInputAtom(
          label: 'Password',
          hint: 'Enter your password',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: PasswordInputAtom,
  path: 'Design System/Atoms/Inputs',
)
Widget buildPasswordInputAtomWithError(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: PasswordInputAtom(
          label: 'Password',
          errorText: 'Password must be at least 8 characters',
        ),
      ),
    ),
  );
}
