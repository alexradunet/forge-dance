import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:flutter_mvvm_riverpod/design_system/design_system.dart';

@widgetbook.UseCase(
  name: 'Playground',
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputPlayground(BuildContext context) {
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
          prefixIcon: context.knobs.listOrNull(
            label: 'Prefix Icon',
            options: [
              Icons.email_outlined,
              Icons.person_outline,
              Icons.lock_outline,
              Icons.search
            ],
            initialOption: Icons.email_outlined,
          ),
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
  name: 'Showcase',
  type: FgInput,
  path: 'Design System/Atoms/Inputs',
)
Widget buildFgInputShowcase(BuildContext context) {
  return Scaffold(
    backgroundColor: AppColors.bgDeep,
    body: SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _InputSection(
            title: 'Standard Variants',
            children: [
              FgInput(
                label: 'Email',
                placeholder: 'john@example.com',
                prefixIcon: Icons.email_outlined,
              ),
              FgInput(
                label: 'Password',
                placeholder: 'Enter password',
                prefixIcon: Icons.lock_outline,
                variant: FgInputVariant.password,
              ),
              FgInput(
                label: 'Search',
                placeholder: 'Search lessons...',
                prefixIcon: Icons.search,
              ),
            ],
          ),
          const SizedBox(height: 48),
          const _InputSection(
            title: 'States',
            children: [
              FgInput(
                label: 'Disabled',
                placeholder: 'Cannot edit',
                isEnabled: false,
              ),
              FgInput(
                label: 'With Error',
                placeholder: 'Invalid entry',
                errorText: 'This field is required',
              ),
              FgInput(
                label: 'With Helper',
                placeholder: 'Optional info',
                helperText: 'Must be at least 8 characters',
              ),
            ],
          ),
          const SizedBox(height: 48),
          _InputSection(
            title: 'Text Area',
            children: [
              FgInput.multiline(
                label: 'Message',
                placeholder: 'Type something...',
              ),
            ],
          ),
        ],
      ),
    ),
  );
}

class _InputSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _InputSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: AppTypography.h5.copyWith(color: AppColors.crystalWhite)),
        const SizedBox(height: 24),
        ...children.map((child) => Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: child,
            )),
      ],
    );
  }
}
