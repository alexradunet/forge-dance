import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import '../../../../design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: ForgeTextInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildForgeTextInputDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ForgeTextInput(
          label: 'Email',
          placeholder: 'Enter your email',
          prefixIcon: Icons.email,
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'With Error',
  type: ForgeTextInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildForgeTextInputError(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ForgeTextInput(
          label: 'Password',
          placeholder: 'Enter password',
          obscureText: true,
          prefixIcon: Icons.lock,
          errorText: 'Password is too short',
        ),
      ),
    ),
  );
}

@widgetbook.UseCase(
  name: 'Search',
  type: ForgeSearchInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildForgeSearchInput(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: ForgeSearchInput(
          placeholder: 'Explore styles, mentors, moves...',
          onFilterPressed: () {},
        ),
      ),
    ),
  );
}
