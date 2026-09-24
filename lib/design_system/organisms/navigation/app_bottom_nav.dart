import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../generated/locale_keys.g.dart';
import '../../design_system.dart';

/// Content-sized navigation: labels wrap at large text instead of being clipped.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTabChange;
  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) => Theme(
    data: MediaQuery.highContrastOf(context)
        ? AppThemes.highContrastDark
        : AppThemes.dark,
    child: Builder(
      builder: (context) => Material(
        color: Theme.of(context).colorScheme.surface,
        child: SafeArea(
          top: false,
          child: Padding(
            padding: AppSpacing.allSM,
            child: Wrap(
              alignment: WrapAlignment.spaceEvenly,
              spacing: AppSpacing.xs,
              runSpacing: AppSpacing.xs,
              children: [
                _item(
                  0,
                  Icons.menu_book_outlined,
                  LocaleKeys.vocabularyTitle.tr(),
                ),
                _item(1, Icons.school_outlined, LocaleKeys.navLearn.tr()),
                _item(2, Icons.home_outlined, LocaleKeys.navHome.tr()),
                _item(3, Icons.fitness_center, LocaleKeys.navPractice.tr()),
                _item(4, Icons.person_outline, LocaleKeys.profileTitle.tr()),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  Widget _item(int index, IconData icon, String label) => FgNavButton(
    icon: icon,
    label: label,
    isActive: currentIndex == index,
    onTap: () => onTabChange(index),
  );
}
