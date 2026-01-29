import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: TextInputAtom,
  path: 'Design System/Atoms/Inputs',
)
Widget buildTextInputAtomDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TextInputAtom(
          label: 'Email',
          icon: Icons.email,
          hint: 'your@email.com',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: TextInputAtom,
  path: 'Design System/Atoms/Inputs',
)
Widget buildTextInputAtomWithError(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: TextInputAtom(
          label: 'Email',
          icon: Icons.email,
          hint: 'your@email.com',
          errorText: 'Invalid email format',
        ),
      ),
    ),
  );
}
