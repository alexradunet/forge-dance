import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/language.dart';
import 'widgets/language_item.dart';

const languages = [
  Language(id: '0', name: 'English', code: 'en', flag: ''),
  Language(id: '1', name: 'Tiếng Việt', code: 'vi', flag: ''),
];

class LanguagesScreen extends StatelessWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.language.tr(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView.separated(
                padding: AppSpacing.allLG,
                itemBuilder: (context, index) => LanguageItem(
                  language: languages[index],
                ),
                separatorBuilder: (_, _) =>
                    const SizedBox(height: AppSpacing.sm),
                itemCount: languages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
