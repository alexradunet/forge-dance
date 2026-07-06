import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/tokens/app_colors.dart';
import '../../../../design_system/tokens/app_spacing.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../design_system/atoms/progress/fg_spinner.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/molecules/cards/fg_interactive_card.dart';
import '../../../../design_system/molecules/cards/fg_interactive_card_thumbnail.dart';
import '../../../../design_system/molecules/feedback/fg_empty.dart';
import '../../../../design_system/atoms/icons/fg_icon.dart';
import '../../../../design_system/organisms/modals/fg_filter_sheet.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../common/ui/widgets/common_error.dart';
import '../../../learn/model/lesson.dart';
import '../../../learn/model/lesson_progress.dart';
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
    final collected = state.collectedLessons;
    final items = collected
        .where((item) =>
            _query.isEmpty ||
            item.lesson.title.toLowerCase().contains(_query) ||
            item.module.title.toLowerCase().contains(_query))
        .toList();

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
          sliver: SliverToBoxAdapter(
            child: _buildSearchBar(),
          ),
        ),

        // Content
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          sliver: SliverToBoxAdapter(
            child: collected.isEmpty
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
                    : _buildGridView(state, items),
          ),
        ),

        const SliverToBoxAdapter(
          child: SizedBox(height: 120),
        ),
      ],
    );
  }

  String _statusLabel(LearnState state, Lesson lesson) {
    return state.statusOf(lesson) == LessonStatus.completed
        ? LocaleKeys.statusCompleted.tr()
        : LocaleKeys.statusInProgress.tr();
  }

  Widget _buildGridView(
    LearnState state,
    List<({Module module, Lesson lesson})> items,
  ) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: _crossAxisCount,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 0.7,
      ),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return FgInteractiveCardThumbnail(
          title: item.lesson.title.toUpperCase(),
          level: _statusLabel(state, item.lesson).toUpperCase(),
          backgroundImage: item.module.imageUrl,
          backTitle: item.module.title.toUpperCase(),
          backSubtitle: item.lesson.type.label,
          onTap: (isFlipped) => _showCardPopup(context, state, item, isFlipped),
        );
      },
    );
  }

  void _showCardPopup(
    BuildContext context,
    LearnState state,
    ({Module module, Lesson lesson}) item,
    bool isFlipped,
  ) {
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
                child: FgInteractiveCard(
                  title: item.lesson.title.toUpperCase(),
                  subtitle: item.module.title,
                  backgroundImage: item.module.imageUrl,
                  level: _statusLabel(state, item.lesson).toUpperCase(),
                  style: item.module.tag,
                  difficulty: item.lesson.difficulty,
                  isFavorited: false,
                  onTap: () {},
                  initialFlipped: isFlipped,
                ),
              ),
            ),
          ),
        );
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
                hintText: LocaleKeys.searchLibraryHint.tr(),
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
}
