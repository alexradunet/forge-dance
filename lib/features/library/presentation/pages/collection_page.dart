import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../common/ui/widgets/primary_button.dart';

class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  String _selectedFilter = 'All Styles';

  final List<String> _filters = [
    'All Styles',
    'Hip Hop',
    'Popping',
    'Break',
    'House',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgDeep,
      body: CustomScrollView(
        slivers: [
          // Header
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                24,
                MediaQuery.paddingOf(context).top + 12,
                24,
                8,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'COLLECTION',
                    style: TextStyle(
                      fontFamily: 'Bebas Neue',
                      fontSize: 42,
                      color: Colors.white,
                      letterSpacing: 2,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(
                      Icons.search,
                      color: AppColors.textMain,
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Filter Chips
          SliverToBoxAdapter(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _filters.map((filter) {
                    final isSelected = filter == _selectedFilter;
                    return Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: GestureDetector(
                        onTap: () {
                          setState(() {
                            _selectedFilter = filter;
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.forgeFire
                                : AppColors.surfaceDark.withOpacity(0.5),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSelected
                                  ? AppColors.forgeFire
                                  : Colors.white.withOpacity(0.05),
                            ),
                          ),
                          child: Text(
                            filter,
                            style: AppTypography.label.copyWith(
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.textMuted,
                              fontWeight: isSelected
                                  ? FontWeight.bold
                                  : FontWeight.w500,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RESOURCES',
              style: AppTypography.label.copyWith(
                color: AppColors.textMuted,
                letterSpacing: 1.5,
              ),
            ),
            Text(
              'VIEW ALL',
              style: AppTypography.label.copyWith(
                color: AppColors.forgeFire,
                fontSize: 10,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Placeholder for cards - using existing design tokens
        const Row(
          children: [
            Expanded(child: _MockCard(title: 'Movements', count: '124')),
            SizedBox(width: 16),
            Expanded(child: _MockCard(title: 'Techniques', count: '48')),
          ],
        ),
        const SizedBox(height: 16),
        const Row(
          children: [
            Expanded(child: _MockCard(title: 'Stretches', count: '32')),
            SizedBox(width: 16),
            Expanded(child: _MockCard(title: 'Warmups', count: '15')),
          ],
        ),
      ],
    );
  }
}

class _MockCard extends StatelessWidget {
  final String title;
  final String count;

  const _MockCard({required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark.withOpacity(0.5),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppColors.bgDeep,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.fitness_center,
                color: AppColors.forgeFire, size: 20),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: AppTypography.h5.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 4),
          Text(
            '$count Items',
            style: AppTypography.caption.copyWith(color: AppColors.textMuted),
          ),
        ],
      ),
    );
  }
}
