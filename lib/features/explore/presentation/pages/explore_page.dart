import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/molecules/cards/fg_content_card.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';

import '../../../../design_system/organisms/modals/app_filter_sheet.dart';

class ExplorePage extends StatefulWidget {
  final Function(String)? onNavigate;

  const ExplorePage({super.key, this.onNavigate});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
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
            SliverToBoxAdapter(
              child: AppHeader(
                title: "Explore",
                subtitle: "Discover",
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              sliver: SliverToBoxAdapter(
                child: _buildSearchBar(),
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Fundamentals",
                titleColor: AppColors.forgeFire,
                children: [
                  FgContentCard(
                    title: "Body Control I",
                    tags: const ["Rhythm"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1550525811-e5869dd03032?w=800&q=80",
                    progress: 0.25,
                    footerLabel: "2/8 Lessons",
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: "Isolations Master",
                    tags: const ["Tech"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80",
                    progress: 0,
                    footerLabel: "0/5 Lessons",
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Street Styles",
                titleColor: Colors.blueAccent,
                children: [
                  FgContentCard(
                    title: "Top Rock",
                    tags: const ["Breaking"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&q=80",
                    progress: 0.60,
                    footerLabel: "3/5 Lessons",
                    width: 180,
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: "Boogaloo",
                    tags: const ["Popping"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1547481887-a26e2cacb2f2?w=800&q=80",
                    progress: 0,
                    footerLabel: "0/4 Lessons",
                    width: 180,
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: "House",
                    tags: const ["House"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=800&q=80",
                    progress: 0.35,
                    footerLabel: "2/6 Lessons",
                    width: 180,
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: _buildSection(
                title: "Choreography",
                titleColor: Colors.purpleAccent,
                children: [
                  FgContentCard(
                    title: "Urban Flow",
                    tags: const ["New Arrival"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&q=80",
                    progress: 0,
                    footerLabel: "0/8 Lessons",
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                  const SizedBox(width: 16),
                  FgContentCard(
                    title: "Contemporary Fusion",
                    tags: const ["Advanced"],
                    imageUrl:
                        "https://images.unsplash.com/photo-1518834107812-67b0b7c58434?w=800&q=80",
                    progress: 0.15,
                    footerLabel: "1/7 Lessons",
                    onTap: () => widget.onNavigate?.call('lesson-path'),
                  ),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 100)),
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
                hintText: "Explore styles, mentors, moves...",
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

  Widget _buildSection({
    required String title,
    required Color titleColor,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Row(
            children: [
              Text(
                title.toUpperCase(),
                style: const TextStyle(
                  color: Colors.white,
                  fontFamily: 'Orbitron',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Container(
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [titleColor.withOpacity(0.4), Colors.transparent],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Row(
            children: children,
          ),
        ),
      ],
    );
  }
}
