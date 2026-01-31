import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Default',
  type: SearchInputAtom,
  path: 'Design System/Atoms/Inputs',
)
Widget buildSearchInputAtomDefault(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.gray950,
    body: Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SearchInputAtom(
          hint: 'Search exercises...',
        ),
      ),
    ),
  );
}
