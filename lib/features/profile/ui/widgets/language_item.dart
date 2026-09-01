import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

import '../../../../design_system/design_system.dart';
import '../../model/language.dart';

class LanguageItem extends StatelessWidget {
  const LanguageItem({super.key, required this.language});

  final Language language;

  @override
  Widget build(BuildContext context) {
    final isSelected = language.code == context.locale.languageCode;

    return FgCard(
      variant: FgCardVariant.outlined,
      padding: EdgeInsets.zero,
      isSelected: isSelected,
      onTap: () => context.setLocale(Locale(language.code)),
      child: ListTile(
        contentPadding: AppSpacing.horizontal,
        title: Text(language.name),
        trailing: isSelected
            ? Icon(
                HugeIcons.strokeRoundedTick01,
                color: Theme.of(context).colorScheme.primary,
                size: AppSizes.iconMd,
              )
            : null,
      ),
    );
  }
}
