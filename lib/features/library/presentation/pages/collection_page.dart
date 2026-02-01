import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/tokens/app_colors.dart';

import '../../../../design_system/atoms/visuals/fg_background.dart';

import '../../../../design_system/organisms/navigation/app_header.dart';
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
  final Map<String, String> _selectedFilters = {
    'Difficulty': 'All',
    'Style': 'All',
    'Type': 'All',
  };

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: CustomScrollView(
          slivers: [
            // Header
            SliverToBoxAdapter(
              child: AppHeader(
                title: 'COLLECTION',
                subtitle: 'Your Library',
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
            ),

            // Content
            const SliverPadding(
              padding: EdgeInsets.symmetric(horizontal: 24),
              sliver: SliverToBoxAdapter(
                child: _CollectionContent(),
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

class _CollectionContent extends StatelessWidget {
  const _CollectionContent();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Mini Interactive Cards Grid
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 0.7,
          children: [
            const AppMiniInteractiveCard(
              title: 'BASIC BOUNCE',
              level: 'BEGINNER',
              backgroundImage:
                  'https://images.unsplash.com/photo-1518611012118-696072aa579a?auto=format&fit=crop&q=80&w=2000',
            ),
            const AppMiniInteractiveCard(
              title: 'RHYTHM GAME',
              level: 'INTERMEDIATE',
              backgroundImage:
                  'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&q=80&w=2000',
            ),
            AppMiniWorkoutCard(
              title: 'HIIT BLAST',
              duration: '20 MIN',
              intensity: 'HIGH',
              onTap: () {},
            ),
            AppMiniWorkoutCard(
              title: 'MORNING FLOW',
              duration: '15 MIN',
              intensity: 'LOW',
              onTap: () {},
            ),
            const AppMiniInteractiveCard(
              title: 'POPPING BASICS',
              level: 'BEGINNER',
              backgroundImage:
                  'https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?auto=format&fit=crop&q=80&w=2000',
            ),
            const AppMiniInteractiveCard(
              title: 'HOUSE GROOVES',
              level: 'INTERMEDIATE',
              backgroundImage:
                  'https://images.unsplash.com/photo-1547153760-18fc86324498?auto=format&fit=crop&q=80&w=2000',
            ),
            AppMiniWorkoutCard(
              title: 'CORE STRENGTH',
              duration: '25 MIN',
              intensity: 'MEDIUM',
              onTap: () {},
            ),
            AppMiniWorkoutCard(
              title: 'FLEXIBILITY',
              duration: '30 MIN',
              intensity: 'LOW',
              onTap: () {},
            ),
            const AppMiniInteractiveCard(
              title: 'BREAKING FOOTWORK',
              level: 'ADVANCED',
              backgroundImage:
                  'https://images.unsplash.com/photo-1535525153412-5a42439a210d?auto=format&fit=crop&q=80&w=2000',
            ),
            AppMiniWorkoutCard(
              title: 'ENDURANCE',
              duration: '45 MIN',
              intensity: 'HIGH',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}
