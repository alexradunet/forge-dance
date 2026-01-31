import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';
import '../../tokens/app_spacing.dart';

class AppHeader extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final Widget? leftSlot;
  final Widget? rightSlot;
  final bool isTransparent;
  final VoidCallback? onBack;

  const AppHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.leftSlot,
    this.rightSlot,
    this.isTransparent = true,
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        24,
        MediaQuery.of(context).padding.top + 12,
        24,
        12,
      ),
      decoration: BoxDecoration(
        color: isTransparent ? Colors.transparent : AppColors.bgDeep,
        border: isTransparent
            ? null
            : Border(bottom: BorderSide(color: Colors.white.withOpacity(0.05))),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Left Slot (Back button + Custom Left)
          Align(
            alignment: Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (onBack != null) ...[
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios,
                        color: Colors.white, size: 20),
                    onPressed: onBack,
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 16),
                ],
                if (leftSlot != null) leftSlot!,
              ],
            ),
          ),

          // Center Title
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (subtitle != null)
                Text(
                  subtitle!.toUpperCase(),
                  style: AppTypography.label.copyWith(
                    color: AppColors.textMuted,
                    fontSize: 10,
                    letterSpacing: 1.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              Text(
                title.toUpperCase(),
                style: AppTypography.h2.copyWith(
                  color: AppColors.textMain,
                  fontSize: 24, // Slightly smaller to fit center
                  letterSpacing: 2,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),

          // Right Slot
          if (rightSlot != null)
            Align(
              alignment: Alignment.centerRight,
              child: rightSlot!,
            ),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
