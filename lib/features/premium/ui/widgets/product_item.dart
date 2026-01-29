import 'package:flutter/material.dart';

import '/design_system/tokens/app_colors.dart';
import '/design_system/tokens/app_typography.dart';
import '../../../common/ui/widgets/material_ink_well.dart';
import '../../model/product.dart';

class ProductItem extends StatelessWidget {
  final Product product;
  final bool isSelected;
  final VoidCallback onTap;

  const ProductItem({
    super.key,
    required this.product,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: MaterialInkWell(
        radius: 16,
        onTap: onTap,
        child: AnimatedContainer(
          padding: EdgeInsets.only(bottom: 24),
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.forgeFire.withAlpha(220)
                : AppColors.gray950.withAlpha(220),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Container(
                alignment: Alignment.topRight,
                margin: EdgeInsets.only(right: 16),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 2,
                    horizontal: 8,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.passionRed,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(8),
                    ),
                  ),
                  child: Text(
                    '- ${product.savePercent}%',
                    style: AppTheme.caption.copyWith(
                      color: AppColors.crystalWhite,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Text(
                product.title,
                style: AppTheme.h6.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                product.currentPrice,
                style: AppTheme.h5.copyWith(
                  color: AppColors.crystalWhite,
                ),
              ),
              const SizedBox(height: 16),
              product.label != null
                  ? Container(
                      margin: EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                        vertical: 4,
                        horizontal: 12,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.crystalWhite.withAlpha(50),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Text(
                        product.label!,
                        style: AppTheme.caption.copyWith(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: AppColors.crystalWhite,
                        ),
                      ),
                    )
                  : const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }
}
