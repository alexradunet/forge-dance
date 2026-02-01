import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import '../model/language.dart';
import 'widgets/language_item.dart';

final languages = [
  const Language(id: '0', name: 'English', code: 'en', flag: ''),
  const Language(id: '1', name: 'Tiếng Việt', code: 'vi', flag: ''),
];

class LanguagesScreen extends ConsumerWidget {
  const LanguagesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: 'language'.tr(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemBuilder: (context, index) => LanguageItem(
                  language: languages[index],
                  isFirst: index == 0,
                  isLast: index == languages.length - 1,
                ),
                itemCount: languages.length,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
