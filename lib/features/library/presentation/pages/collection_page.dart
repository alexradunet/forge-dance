import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';

import '../../../../design_system/atoms/visuals/fg_background.dart';

import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/organisms/cards/app_interactive_card.dart';
import '../../../../design_system/molecules/cards/app_mini_interactive_card.dart';
import '../../../../design_system/molecules/cards/app_mini_workout_card.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/organisms/modals/app_filter_sheet.dart';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  final TextEditingController _searchController = TextEditingController();
  int _crossAxisCount = 2;
  final Map<String, String> _selectedFilters = {
    'Difficulty': 'All',
    'Style': 'All',
    'Type': 'All',
  };

  // Mock Data
  final List<Map<String, dynamic>> _items = [
    {
      'type': 'interactive',
      'title': 'BASIC BOUNCE',
      'level': 'BEGINNER',
      'backgroundImage':
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
    },
    {
      'type': 'interactive',
      'title': 'RHYTHM GAME',
      'level': 'INTERMEDIATE',
      'backgroundImage':
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000',
    },
    {
      'type': 'workout',
      'title': 'HIIT BLAST',
      'duration': '20 MIN',
      'intensity': 'HIGH',
    },
    {
      'type': 'workout',
      'title': 'MORNING FLOW',
      'duration': '15 MIN',
      'intensity': 'LOW',
    },
    {
      'type': 'interactive',
      'title': 'POPPING BASICS',
      'level': 'BEGINNER',
      'backgroundImage':
          'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&q=80&w=2000',
    },
    {
      'type': 'interactive',
      'title': 'HOUSE GROOVES',
      'level': 'INTERMEDIATE',
      'backgroundImage':
          'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=2000',
    },
    {
      'type': 'workout',
      'title': 'CORE STRENGTH',
      'duration': '25 MIN',
      'intensity': 'MEDIUM',
    },
    {
      'type': 'workout',
      'title': 'FLEXIBILITY',
      'duration': '30 MIN',
      'intensity': 'LOW',
    },
    {
      'type': 'interactive',
      'title': 'BREAKING FOOTWORK',
      'level': 'ADVANCED',
      'backgroundImage':
          'https://images.unsplash.com/photo-1535525153412-5a42439a210d?auto=format&fit=crop&q=80&w=2000',
    },
    {
      'type': 'workout',
      'title': 'ENDURANCE',
      'duration': '45 MIN',
      'intensity': 'HIGH',
    },
  ];

  void _showFilterSheet() {
    AppFilterSheet.show(
      context: context,
      sections: {
        'Difficulty': ['All', 'Beginner', 'Intermediate', 'Advanced'],
        'Style': [
          'All',
          'Hip Hop',
          'Breaking',
          'Contemporary',
          'Freestyle',
          'General'
        ],
        'Type': ['All', 'Drill', 'Dance Step', 'Concept'],
      },
      selectedFilters: _selectedFilters,
      onFilterSelected: (section, value) {
        setState(() {
          _selectedFilters[section] = value;
        });
      },
      onReset: () {
        setState(() {
          _selectedFilters.updateAll((key, value) => 'All');
        });
        Navigator.pop(context);
      },
      onApply: () {
        // Apply logic here
        Navigator.pop(context);
      },
    );
  }

  Widget _buildColumnToggle() {
    return PopupMenuButton<int>(
      icon: const FgIcon(icon: Icons.grid_view, color: Colors.white, size: 24),
      color: AppColors.surfaceDark,
      offset: const Offset(0, 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      onSelected: (value) {
        setState(() {
          _crossAxisCount = value;
        });
      },
      itemBuilder: (context) => [
        _buildPopupMenuItem(2, "2 Columns"),
        _buildPopupMenuItem(3, "3 Columns"),
        _buildPopupMenuItem(4, "4 Columns"),
      ],
    );
  }

  PopupMenuItem<int> _buildPopupMenuItem(int value, String text) {
    return PopupMenuItem(
      value: value,
      child: Row(
        children: [
          Icon(
            _crossAxisCount == value
                ? Icons.radio_button_checked
                : Icons.radio_button_unchecked,
            color: _crossAxisCount == value
                ? AppColors.forgeFire
                : AppColors.textMuted,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }

  void _showCardPopup(BuildContext context, Map<String, dynamic> item) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.9),
      builder: (context) {
        return Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 500,
              maxHeight: 800,
            ),
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: AppInteractiveCard(
                  title: item['title'],
                  subtitle: item['level'] ?? item['duration'],
                  backgroundImage: item['backgroundImage'] ??
                      'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
                  level: item['level'],
                  style: item['type'] == 'workout' ? 'Workout' : 'Interactive',
                  difficulty: item['level'] ?? item['intensity'],
                  mini: false,
                  isFavorited: false,
                  onTap: () {},
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: AppHeader(
                title: 'COLLECTION',
                subtitle: 'Your Library',
                rightSlot: _buildColumnToggle(),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.xxl,
                top: AppSpacing.lg,
                bottom: AppSpacing.sm,
              ),
              sliver: SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
            ),

            // Content
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _buildGridView(),
              ),
            ),

            const SliverToBoxAdapter(
              child: SizedBox(height: 120),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: _items.length,
      itemBuilder: (context, index) {
        final item = _items[index];
        if (item['type'] == 'interactive') {
          return AppMiniInteractiveCard(
            title: item['title'],
            level: item['level'],
            backgroundImage: item['backgroundImage'],
            onTap: () => _showCardPopup(context, item),
          );
        }
      },
    );
  }

  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const FgIcon(icon: Icons.search, color: AppColors.textMuted),
          const SizedBox(width: 12),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: const TextStyle(color: Colors.white, fontSize: 14),
              decoration: const InputDecoration(
                hintText: "Search in your library...",
                hintStyle: TextStyle(color: AppColors.textDark, fontSize: 14),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ),
          GestureDetector(
            onTap: _showFilterSheet,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const FgIcon(
                  icon: Icons.tune, color: AppColors.textMuted, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
