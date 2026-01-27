import 'dart:io';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../theme/app_colors.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/global_loading.dart';
import '../../common/ui/widgets/common_close_button.dart';
import '../../common/ui/widgets/primary_button.dart';
import 'view_model/premium_view_model.dart';
import 'widgets/benefit_item.dart';
import 'widgets/premium_agreement.dart';
import 'widgets/product_item.dart';

class PremiumScreen extends ConsumerWidget {
  const PremiumScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(premiumViewModelProvider, (previous, next) {
      if (previous != next) {
        if (next.isLoading) {
          Global.showLoading(context);
        } else {
          Global.hideLoading();
        }
      }

      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }

      if (next is AsyncData) {
        if (next.value?.isPurchaseSuccessfully == true) {
          context.showSuccessSnackBar(LocaleKeys.purchaseSuccess);
          context.pop();
        }
        if (next.value?.isRestoreSuccessfully == true) {
          context.showSuccessSnackBar(LocaleKeys.restorePurchasesSuccess);
          context.pop();
        } else if (next.value?.isRestoreSuccessfully == false) {
          context.showWarningSnackBar(LocaleKeys.noActivePurchases);
        }
      }
    });

    final premiumState = ref.watch(premiumViewModelProvider);
    final products = premiumState.value?.products ?? defaultProducts;
    final selectedIndex = premiumState.value?.selectedIndex ?? 1;

    return Scaffold(
      backgroundColor: AppColors.gray950,
      body: Stack(
        children: [
          Image(image: AssetImage(Assets.premiumBackground)),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.gray950.withOpacity(0.33),
                  AppColors.gray950.withOpacity(0.66),
                  AppColors.gray950,
                ],
              ),
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      SizedBox(width: 36),
                      Text(
                        LocaleKeys.premium,
                        style: AppTheme.h1.copyWith(
                          color: AppColors.crystalWhite,
                        ),
                      ),
                      CommonCloseButton(color: AppColors.crystalWhite),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(16, 0, 16, 256),
                    children: [
                      Text(
                        LocaleKeys.premiumBenefits,
                        style: AppTheme.h2.copyWith(
                          color: AppColors.crystalWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.gray950.withAlpha(220),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          spacing: 16,
                          children: benefits
                              .map((benefit) => BenefitItem(
                                    icon: benefit.icon,
                                    title: benefit.title,
                                    description: benefit.description,
                                  ))
                              .toList(),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        LocaleKeys.selectPlan,
                        style: AppTheme.h2.copyWith(
                          color: AppColors.crystalWhite,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Row(
                        spacing: 16,
                        children: products
                            .mapIndexed(
                              (index, product) => ProductItem(
                                product: product,
                                isSelected: selectedIndex == index,
                                onTap: () => ref
                                    .read(premiumViewModelProvider.notifier)
                                    .selectProduct(index),
                              ),
                            )
                            .toList(),
                      ),
                      const SizedBox(height: 24),
                      Text(
                        '* ${products[selectedIndex].description}',
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.gray200,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        Platform.isIOS
                            ? LocaleKeys.subscriptionInfoIos.tr()
                            : LocaleKeys.subscriptionInfoAndroid.tr(),
                        style: AppTheme.bodySmall.copyWith(
                          color: AppColors.crystalWhite,
                        ),
                        textAlign: TextAlign.justify,
                      ),
                      const SizedBox(height: 8),
                      PremiumAgreement(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              padding: EdgeInsets.fromLTRB(
                16,
                0,
                16,
                MediaQuery.paddingOf(context).bottom + 16,
              ),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.gray950.withOpacity(0),
                    AppColors.gray950,
                    AppColors.gray950,
                    AppColors.gray950,
                  ],
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  PrimaryButton(
                    text: LocaleKeys.continueText,
                    onPressed: () =>
                        ref.read(premiumViewModelProvider.notifier).purchase(),
                  ),
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: () => ref
                        .read(premiumViewModelProvider.notifier)
                        .restorePurchases(),
                    child: Text(
                      LocaleKeys.restorePurchases,
                      style: AppTheme.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.crystalWhite,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
