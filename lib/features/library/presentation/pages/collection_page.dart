import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/model/lesson_progress.dart';
import '../../../learn/model/library_projection.dart';
import '../../../learn/ui/state/learn_state.dart';
import '../../../learn/ui/view_model/learn_view_model.dart';

/// Collection — the user's library: every lesson they have started or
/// completed, straight from users/{uid}/progress. Empty until real training
/// happens; searchable by lesson or module title.
class CollectionPage extends ConsumerStatefulWidget {
  const CollectionPage({super.key});

  @override
  ConsumerState<CollectionPage> createState() => _CollectionPageState();
}

class _CollectionPageState extends ConsumerState<CollectionPage> {
  final TextEditingController _searchController = TextEditingController();
  int _crossAxisCount = 2;
  String _query = '';

  Map<String, String> _selectedFilters = {
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
    final projection = ref.read(learnViewModelProvider).value?.library;
    if (projection == null) return;
    final draft = {..._selectedFilters};
    FgFilterSheet.show(
      context: context,
      title: LocaleKeys.filters.tr(),
      resetLabel: LocaleKeys.reset.tr(),
      applyLabel: LocaleKeys.applyFilters.tr(),
      sections: {
        'Difficulty': ['All', ...projection.difficulties],
        'Style': ['All', ...projection.styles],
        'Type': ['All', ...projection.types],
      },
      selectedFilters: draft,
      onFilterSelected: (section, value) {
        draft[section] = value;
      },
      onReset: () {
        setState(() {
          _selectedFilters = {
            for (final key in _selectedFilters.keys) key: 'All',
          };
        });
        Navigator.pop(context);
      },
      onApply: () {
        setState(() => _selectedFilters = draft);
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
    final projection = state.library;
    final items = projection.matching(
      query: _query,
      difficulty: _filter('Difficulty'),
      style: _filter('Style'),
      type: _filter('Type'),
    );

    return CustomScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      slivers: [
        // Header
        SliverToBoxAdapter(
          child: AppHeader(
            title: LocaleKeys.collectionTitle.tr().toUpperCase(),
            subtitle: LocaleKeys.collectionSubtitle.tr(),
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
          sliver: SliverToBoxAdapter(child: _buildSearchBar()),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl),
          sliver: SliverToBoxAdapter(
            child: projection.entries.isEmpty
                ? FgEmpty(
                    icon: Icons.library_music,
                    title: LocaleKeys.emptyLibraryTitle.tr(),
                    description: LocaleKeys.emptyLibrarySubtitle.tr(),
                  )
                : items.isEmpty
                ? FgEmpty(
                    icon: Icons.search_off,
                    title: LocaleKeys.noResults.tr(),
                    description: LocaleKeys.searchLibraryHint.tr(),
                  )
                : _buildGridView(items),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: AppSizes.bottomNavHeight + AppSpacing.xxxl),
        ),
      ],
    );
  }

  String _statusLabel(LessonStatus status) {
    return status == LessonStatus.completed
        ? LocaleKeys.statusCompleted.tr()
        : LocaleKeys.statusInProgress.tr();
  }

  Widget _buildGridView(List<LibraryEntry> items) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: AppSpacing.lg,
        crossAxisSpacing: AppSpacing.lg,
        childAspectRatio: AppSizes.lessonCardAspectRatio,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FgInteractiveCardThumbnail(
          title: item.lesson.title.toUpperCase(),
          level: _statusLabel(item.status).toUpperCase(),
          flipSemanticLabel: LocaleKeys.flipCard.tr(),
          backgroundImage: item.module.imageUrl,
          backTitle: item.module.title.toUpperCase(),
          backSubtitle: item.lesson.type.label,
          onTap: (isFlipped) => _showCardPopup(context, item, isFlipped),
        );
      },
    );
  }

  void _showCardPopup(BuildContext context, LibraryEntry item, bool isFlipped) {
    ForgeBottomSheet.show<void>(
      context: context,
      title: item.lesson.title,
      child: FgAspectRatio.portrait(
        child: FgInteractiveCard(
          title: item.lesson.title.toUpperCase(),
          flipSemanticLabel: LocaleKeys.flipCard.tr(),
          subtitle: item.module.title,
          backgroundImage: item.module.imageUrl,
          level: _statusLabel(item.status).toUpperCase(),
          style: item.module.tag,
          difficulty: item.lesson.difficulty,
          isFavorited: false,
          initialFlipped: isFlipped,
        ),
      ),
    );
  }

  String? _filter(String name) {
    final value = _selectedFilters[name];
    return value == null || value == 'All' ? null : value;
  }

  Widget _buildColumnToggle() {
    return FgMenuButton<int>(
      icon: Icons.grid_view_rounded,
      semanticLabel: LocaleKeys.chooseGridColumns.tr(),
      items: [
        for (final columns in const [2, 3, 4])
          FgMenuItem(
            value: columns,
            label: LocaleKeys.gridColumns.tr(args: ['$columns']),
            isSelected: columns == _crossAxisCount,
          ),
      ],
      onSelected: (value) => setState(() => _crossAxisCount = value),
    );
  }

  Widget _buildSearchBar() {
    return FgInput.search(
      controller: _searchController,
      placeholder: LocaleKeys.searchLibraryHint.tr(),
      onClear: _searchController.clear,
      clearSemanticsLabel: LocaleKeys.clearSearch.tr(),
      showFilter: true,
      onFilterPressed: _showFilterSheet,
      filterSemanticsLabel: LocaleKeys.filterSearch.tr(),
    );
  }
}
