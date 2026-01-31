import 'package:flutter/material.dart';
import '../../../../design_system/tokens/app_colors.dart';

import '../../../../design_system/molecules/cards/app_module_card.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/fg_icon.dart';

class ExplorePage extends StatefulWidget {
  final Function(String)? onNavigate;

  const ExplorePage({super.key, this.onNavigate});

  @override
  State<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends State<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: AppHeader(
              title: "Explore",
              subtitle: "Discover",
              onBack: widget.onNavigate != null
                  ? () => widget.onNavigate!('home')
                  : null,
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
                AppModuleCard(
                  title: "Body Control I",
                  category: "Rhythm",
                  imageUrl:
                      "https://images.unsplash.com/photo-1550525811-e5869dd03032?w=800&q=80",
                  progress: 25,
                  completedLessons: 2,
                  totalLessons: 8,
                  type: AppModuleCardType.large,
                  onTap: () => widget.onNavigate?.call('lesson-path'),
                ),
                const SizedBox(width: 16),
                AppModuleCard(
                  title: "Isolations Master",
                  category: "Tech",
                  imageUrl:
                      "https://images.unsplash.com/photo-1547153760-18fc86324498?w=800&q=80",
                  progress: 0,
                  completedLessons: 0,
                  totalLessons: 5,
                  type: AppModuleCardType.large,
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
                AppModuleCard(
                  title: "Top Rock",
                  category: "Breaking",
                  imageUrl:
                      "https://images.unsplash.com/photo-1535525153412-5a42439a210d?w=800&q=80",
                  progress: 60,
                  completedLessons: 3,
                  totalLessons: 5,
                  type: AppModuleCardType.small,
                  onTap: () => widget.onNavigate?.call('lesson-path'),
                ),
                const SizedBox(width: 16),
                AppModuleCard(
                  title: "Boogaloo",
                  category: "Popping",
                  imageUrl:
                      "https://images.unsplash.com/photo-1547481887-a26e2cacb2f2?w=800&q=80",
                  progress: 0,
                  completedLessons: 0,
                  totalLessons: 4,
                  type: AppModuleCardType.small,
                  onTap: () => widget.onNavigate?.call('lesson-path'),
                ),
                const SizedBox(width: 16),
                AppModuleCard(
                  title: "House",
                  category: "House",
                  imageUrl:
                      "https://images.unsplash.com/photo-1504609813442-a8924e83f76e?w=800&q=80",
                  progress: 35,
                  completedLessons: 2,
                  totalLessons: 6,
                  type: AppModuleCardType.small,
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
                AppModuleCard(
                  title: "Urban Flow",
                  category: "New Arrival",
                  imageUrl:
                      "https://images.unsplash.com/photo-1508700115892-45ecd05ae2ad?w=800&q=80",
                  progress: 0,
                  completedLessons: 0,
                  totalLessons: 8,
                  type: AppModuleCardType.large,
                  onTap: () => widget.onNavigate?.call('lesson-path'),
                ),
                const SizedBox(width: 16),
                AppModuleCard(
                  title: "Contemporary Fusion",
                  category: "Advanced",
                  imageUrl:
                      "https://images.unsplash.com/photo-1518834107812-67b0b7c58434?w=800&q=80",
                  progress: 15,
                  completedLessons: 1,
                  totalLessons: 7,
                  type: AppModuleCardType.large,
                  onTap: () => widget.onNavigate?.call('lesson-path'),
                ),
              ],
            ),
          ),
          const SliverToBoxAdapter(child: SizedBox(height: 100)),
        ],
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
            onTap: () {
              // Show filter modal
            },
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
