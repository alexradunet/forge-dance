import 'dart:ui';
import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../molecules/navigation/app_nav_button.dart';

class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
          16, 8, 16, 16 + MediaQuery.of(context).padding.bottom),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            height: 72,
            decoration: BoxDecoration(
              color: AppColors.surfaceDark.withOpacity(0.95),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: Colors.white.withOpacity(0.1)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildBatItem(0, Icons.favorite_outline, 'Collection'),
                _buildBatItem(1, Icons.school_outlined, 'Learn'),
                _buildBatItem(2, Icons.home_outlined, 'Home'),
                _buildBatItem(3, Icons.bar_chart_rounded, 'Progress'),
                _buildBatItem(4, Icons.person_outline, 'Profile'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBatItem(int index, IconData icon, String label) {
    return AppNavButton(
      icon: icon,
      label: label,
      isActive: currentIndex == index,
      onTap: () => onTabChange(index),
    );
  }
}
