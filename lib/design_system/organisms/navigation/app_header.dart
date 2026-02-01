import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../tokens/app_typography.dart';

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
        MediaQuery.of(context).padding.top + 24,
        24,
        24,
      ),
      decoration: BoxDecoration(
        color: isTransparent ? null : AppColors.bgDeep,
        gradient: isTransparent
            ? LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  AppColors.bgDeep,
                  AppColors.bgDeep.withOpacity(0.95),
                  Colors.transparent,
                ],
              )
            : null,
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
                    icon: const Icon(Icons.arrow_back, // Standard arrow
                        color: Colors.white,
                        size: 24),
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
              Text(
                title.toUpperCase(),
                style: AppTypography.h2.copyWith(
                  color: AppColors.textMain,
                  fontSize: 24, // Slightly smaller to fit center
                  letterSpacing: 2,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.5),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
              ),
              if (subtitle != null)
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Text(
                    subtitle!.toUpperCase(),
                    style: AppTypography.label.copyWith(
                      color: AppColors.forgeFire,
                      fontSize: 10,
                      letterSpacing: 2,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
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
