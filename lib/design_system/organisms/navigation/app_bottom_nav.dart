import 'package:flutter/material.dart';

import '../../tokens/app_colors.dart';
import '../../molecules/navigation/fg_app_nav_button.dart';
import '../../atoms/visuals/fg_glass_container.dart';

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
          24, 8, 24, 16 + MediaQuery.of(context).padding.bottom),
      child: FgGlassContainer(
        height: 72,
        borderRadius: 24,
        blurSigma: 20,
        color: AppColors.surfaceDark,
        opacity: 0.95,
        borderWidth: 1,
        borderColor: Colors.white.withOpacity(0.1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _buildBatItem(0, Icons.favorite_outline, 'Collection'),
            _buildBatItem(1, Icons.school_outlined, 'Learn'),
            _buildBatItem(2, Icons.home_outlined, 'Home'),
            _buildBatItem(3, Icons.fitness_center, 'Workout'),
            _buildBatItem(4, Icons.person_outline, 'Profile'),
          ],
        ),
      ),
    );
  }

  Widget _buildBatItem(int index, IconData icon, String label) {
    return FgNavButton(
      icon: icon,
      label: label,
      isActive: currentIndex == index,
      onTap: () => onTabChange(index),
    );
  }
}
