import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_typography.dart';
import '../../../../design_system/molecules/cards/fg_content_card.dart';
import '../../../../design_system/molecules/feedback/fg_empty.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../design_system/organisms/modals/fg_filter_sheet.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';

/// Explore — the full module catalog grouped by category, with live title
/// search and real per-module progress. The filter sheet is cosmetic until
/// modules carry difficulty metadata.
class ExplorePage extends ConsumerStatefulWidget {
  final Function(String)? onNavigate;

  const ExplorePage({super.key, this.onNavigate});

  @override
  ConsumerState<ExplorePage> createState() => _ExplorePageState();
}

class _ExplorePageState extends ConsumerState<ExplorePage> {
  final TextEditingController _searchController = TextEditingController();
  String _query = '';

  final Map<String, String> _selectedFilters = {
    'Difficulty': 'All',
    'Style': 'All',
    'Type': 'All',
  };

  @override
  void initState() {
    super.initState();
    _searchController.addListener(() {
      setState(() => _query = _searchController.text.trim().toLowerCase());
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showFilterSheet() {
    FgFilterSheet.show(
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
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final learnState = ref.watch(learnViewModelProvider);

    return Scaffold(
      backgroundColor: Colors.transparent, // Background handled by FgBackground
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, __) => const CommonError(),
          data: (state) => _buildContent(state),
        ),
      ),
    );
  }

  Widget _buildContent(LearnState state) {
    final sections = [
      for (final category in ModuleCategory.values)
        (category: category, modules: _modulesFor(state, category)),
    ];
    final nothingMatches =
        sections.every((section) => section.modules.isEmpty);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.exploreTitle.tr(),
            subtitle: LocaleKeys.exploreSubtitle.tr(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          sliver: SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
        ),
        if (nothingMatches)
          SliverToBoxAdapter(
            child: FgEmpty(
              icon: Icons.search_off,
              title: LocaleKeys.noResults.tr(),
              description: LocaleKeys.searchExploreHint.tr(),
            ),
          )
        else
          for (final section in sections)
            if (section.modules.isNotEmpty)
              SliverToBoxAdapter(
                child: _buildSection(
                  title: _categoryLabel(section.category),
                  titleColor: _categoryColor(section.category),
                  children: _moduleCards(state, section),
                ),
              ),
        const SliverToBoxAdapter(child: SizedBox(height: 100)),
      ],
    );
  }

  List<Module> _modulesFor(LearnState state, ModuleCategory category) {
    return state.modules
        .where((module) =>
            module.category == category &&
            (_query.isEmpty ||
                module.title.toLowerCase().contains(_query) ||
                module.tag.toLowerCase().contains(_query)))
        .toList();
  }

  String _categoryLabel(ModuleCategory category) {
    switch (category) {
      case ModuleCategory.fundamentals:
        return LocaleKeys.categoryFundamentals.tr();
      case ModuleCategory.streetStyles:
        return LocaleKeys.categoryStreetStyles.tr();
      case ModuleCategory.choreography:
        return LocaleKeys.categoryChoreography.tr();
    }
  }

  Color _categoryColor(ModuleCategory category) {
    switch (category) {
      case ModuleCategory.fundamentals:
        return AppColors.forgeFire;
      case ModuleCategory.streetStyles:
        return AppColors.electricBlue;
      case ModuleCategory.choreography:
        return AppColors.mysticPurple;
    }
  }

  List<Widget> _moduleCards(
    LearnState state,
    ({ModuleCategory category, List<Module> modules}) section,
  ) {
    // Street styles keep the narrower card format from the original layout.
    final width =
        section.category == ModuleCategory.streetStyles ? 180.0 : null;

    return [
      for (var i = 0; i < section.modules.length; i++) ...[
        if (i > 0) const SizedBox(width: 16),
        _moduleCard(state, section.modules[i], width: width),
      ],
    ];
  }

  Widget _moduleCard(LearnState state, Module module, {double? width}) {
    return FgContentCard(
      title: module.title,
      tags: [module.tag],
      imageUrl: module.imageUrl,
      progress: state.moduleProgressOf(module),
      footerLabel: LocaleKeys.lessonsCompletedOf.tr(
        args: [
          '${state.completedCountIn(module)}',
          '${module.lessons.length}',
        ],
      ),
      width: width,
      onTap: () {
        ref.read(learnViewModelProvider.notifier).selectModule(module.id);
        widget.onNavigate?.call('lesson-path');
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
              decoration: InputDecoration(
                hintText: LocaleKeys.searchExploreHint.tr(),
                hintStyle:
                    const TextStyle(color: AppColors.textDark, fontSize: 14),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 16),
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
                style: AppTypography.h3.copyWith(
                  color: Colors.white,
                  fontSize: 18,
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
