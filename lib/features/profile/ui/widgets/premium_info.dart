import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '/generated/locale_keys.g.dart';
import '../../../../extensions/date_time_extension.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';

class PremiumInfo extends StatelessWidget {
  final DateTime? expiryDate;

  const PremiumInfo({super.key, required this.expiryDate});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 32),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.legendGold.withOpacity(0.6),
            AppColors.legendGold,
          ],
        ),
      ),
      child: expiryDate == null
          ? Text(
              LocaleKeys.premiumLifetime.tr(),
              style: AppTheme.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.gray950,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  LocaleKeys.premium.tr(),
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray950,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  LocaleKeys.until.tr(),
                  style: AppTheme.bodySmall.copyWith(
                    color: AppColors.gray950,
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  (expiryDate ?? DateTime.now()).toddMMYYYY(),
                  style: AppTheme.bodySmall.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.gray950,
                  ),
                ),
              ],
            ),
    );
  }
}
