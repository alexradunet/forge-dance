import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';
import '../../../../routing/routes.dart';

/// Explore — the full module catalog grouped by category, with live title
/// search and real per-module progress. The filter sheet is cosmetic until
/// modules carry difficulty metadata.
class ExplorePage extends ConsumerStatefulWidget {
  const ExplorePage({super.key});

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
      title: LocaleKeys.filters.tr(),
      resetLabel: LocaleKeys.reset.tr(),
      applyLabel: LocaleKeys.applyFilters.tr(),
      sections: {
        'Difficulty': ['All', 'Beginner', 'Intermediate', 'Advanced'],
        'Style': [
          'All',
          'Hip Hop',
          'Breaking',
          'Contemporary',
          'Freestyle',
          'General',
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
      body: FgBackground(
        child: learnState.when(
          loading: () => const Center(child: FgSpinner()),
          error: (_, _) => FgEmpty(
            icon: Icons.error_outline,
            title: LocaleKeys.unexpectedErrorOccurred.tr(),
            tone: FgEmptyTone.error,
          ),
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
    final nothingMatches = sections.every((section) => section.modules.isEmpty);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.exploreTitle.tr(),
            subtitle: LocaleKeys.exploreSubtitle.tr(),
          ),
        ),
        SliverPadding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          sliver: SliverToBoxAdapter(child: _buildSearchBar()),
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
                  dividerTone: _categoryTone(section.category),
                  children: _moduleCards(state, section),
                ),
              ),
        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.bottomNavHeight + AppSpacing.lg),
        ),
      ],
    );
  }

  List<Module> _modulesFor(LearnState state, ModuleCategory category) {
    return state.modules
        .where(
          (module) =>
              module.category == category &&
              (_query.isEmpty ||
                  module.title.toLowerCase().contains(_query) ||
                  module.tag.toLowerCase().contains(_query)),
        )
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

  FgDividerTone _categoryTone(ModuleCategory category) {
    return switch (category) {
      ModuleCategory.fundamentals => FgDividerTone.primary,
      ModuleCategory.streetStyles => FgDividerTone.secondary,
      ModuleCategory.choreography => FgDividerTone.reward,
    };
  }

  List<Widget> _moduleCards(
    LearnState state,
    ({ModuleCategory category, List<Module> modules}) section,
  ) {
    // Street styles keep the narrower card format from the original layout.
    final width = section.category == ModuleCategory.streetStyles
        ? AppSizes.cardCompactWidth
        : null;

    return [
      for (var i = 0; i < section.modules.length; i++) ...[
        if (i > 0) const SizedBox(width: AppSpacing.lg),
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
        args: ['${state.completedCountIn(module)}', '${module.lessons.length}'],
      ),
      width: width,
      onTap: () {
        ref.read(learnViewModelProvider.notifier).selectModule(module.id);
        ModuleDestination(module.id).push<void>(context);
      },
    );
  }

  Widget _buildSearchBar() {
    return FgInput.search(
      controller: _searchController,
      placeholder: LocaleKeys.searchExploreHint.tr(),
      onClear: _searchController.clear,
      clearSemanticsLabel: LocaleKeys.clearSearch.tr(),
      showFilter: true,
      onFilterPressed: _showFilterSheet,
      filterSemanticsLabel: LocaleKeys.filterSearch.tr(),
    );
  }

  Widget _buildSection({
    required String title,
    required FgDividerTone dividerTone,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xxl,
            vertical: AppSpacing.lg,
          ),
          child: Row(
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Theme.of(context).forgeColors.onImmersive,
                ),
              ),
              const SizedBox(width: AppSpacing.lg),
              Expanded(child: FgDivider.horizontal(tone: dividerTone)),
            ],
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          child: Row(children: children),
        ),
      ],
    );
  }
}
