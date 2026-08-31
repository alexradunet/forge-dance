import 'package:flutter/material.dart';

import '../../../../design_system/atoms/buttons/fg_button.dart';
import '../../../../design_system/tokens/app_border_radius.dart';
import '../../../../design_system/tokens/app_spacing.dart';

class CommonDialog extends StatelessWidget {
  final String title;
  final String content;
  final String primaryButtonLabel;
  final VoidCallback? primaryButtonAction;
  final FgButtonVariant primaryButtonVariant;
  final String? secondaryButtonLabel;
  final VoidCallback? secondaryButtonAction;

  const CommonDialog({
    super.key,
    required this.title,
    required this.content,
    required this.primaryButtonLabel,
    this.primaryButtonAction,
    this.primaryButtonVariant = FgButtonVariant.primary,
    this.secondaryButtonLabel,
    this.secondaryButtonAction,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: AppSpacing.horizontalXXL,
      shape: const RoundedRectangleBorder(
        borderRadius: AppBorderRadius.xxLarge,
      ),
      child: Padding(
        padding: AppSpacing.allXXL,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: AppSpacing.lg),
            Text(content, style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: AppSpacing.xxl),
            if (secondaryButtonLabel case final label?)
              Row(
                children: [
                  Expanded(
                    child: FgButton(
                      text: label,
                      variant: FgButtonVariant.secondary,
                      onPressed: () {
                        secondaryButtonAction?.call();
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(child: _primaryButton(context)),
                ],
              )
            else
              _primaryButton(context),
          ],
        ),
      ),
    );
  }

  Widget _primaryButton(BuildContext context) {
    return FgButton(
      text: primaryButtonLabel,
      variant: primaryButtonVariant,
      expand: true,
      onPressed: () {
        primaryButtonAction?.call();
        Navigator.of(context).pop();
      },
    );
  }
}
