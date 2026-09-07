import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../model/vocabulary_entry.dart';
import '../repository/vocabulary_repository.dart';
import 'vocabulary_view_model.dart';

String vocabularyKindLabel(VocabularyKind kind) => switch (kind) {
  VocabularyKind.move => LocaleKeys.vocabularyMoves.tr(),
  VocabularyKind.concept => LocaleKeys.vocabularyConcepts.tr(),
};

class VocabularyPage extends ConsumerStatefulWidget {
  const VocabularyPage({super.key});

  @override
  ConsumerState<VocabularyPage> createState() => _VocabularyPageState();
}

class _VocabularyPageState extends ConsumerState<VocabularyPage> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filters = ref.watch(vocabularyViewModelProvider);
    final entries = ref.watch(vocabularyResultsProvider);
    final introduced = ref.watch(vocabularyIntroducedIdsProvider);
    final notifier = ref.read(vocabularyViewModelProvider.notifier);
    final theme = Theme.of(context);
    return Scaffold(
      body: FgBackground(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppHeader(
                title: LocaleKeys.vocabularyTitle.tr(),
                subtitle: LocaleKeys.vocabularySubtitle.tr(),
              ),
            ),
            SliverPadding(
              padding: AppSpacing.screen,
              sliver: SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    FgInput.search(
                      controller: _searchController,
                      placeholder: LocaleKeys.vocabularySearch.tr(),
                      onChanged: notifier.search,
                      onClear: () {
                        _searchController.clear();
                        notifier.search('');
                      },
                      clearSemanticsLabel: LocaleKeys.clearSearch.tr(),
                      showFilter: false,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        FgFilterChip(
                          label: LocaleKeys.vocabularyAll.tr(),
                          isSelected: filters.kind == null,
                          onSelected: (_) => notifier.selectKind(null),
                        ),
                        for (final kind in VocabularyKind.values)
                          FgFilterChip(
                            label: vocabularyKindLabel(kind),
                            isSelected: filters.kind == kind,
                            onSelected: (_) => notifier.selectKind(kind),
                          ),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: [
                        FgFilterChip(
                          label: LocaleKeys.vocabularyAllStyles.tr(),
                          isSelected: filters.style == null,
                          onSelected: (_) => notifier.selectStyle(null),
                        ),
                        for (final style in const VocabularyRepository().styles)
                          FgFilterChip(
                            label: style,
                            isSelected: filters.style == style,
                            onSelected: (_) => notifier.selectStyle(style),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            if (entries.isEmpty)
              SliverToBoxAdapter(
                child: FgEmpty(
                  icon: Icons.search_off,
                  title: LocaleKeys.noResults.tr(),
                  description: LocaleKeys.vocabularyNoResults.tr(),
                ),
              ),
            SliverPadding(
              padding: AppSpacing.screen,
              sliver: SliverList.builder(
                itemCount: entries.length,
                itemBuilder: (context, index) {
                  final entry = entries[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: FgCard(
                      immersive: true,
                      onTap: () =>
                          VocabularyDestination(entry.id).push<void>(context),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  entry.name,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    color: theme.forgeColors.onImmersive,
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.chevron_right,
                                color: theme.forgeColors.onImmersiveMuted,
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            '${vocabularyKindLabel(entry.kind)} • ${entry.style}',
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.forgeColors.onImmersiveMuted,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            entry.definition,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.forgeColors.onImmersive,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.sm),
                          Text(
                            introduced.contains(entry.id)
                                ? LocaleKeys.vocabularyIntroduced.tr()
                                : LocaleKeys.vocabularyUnexplored.tr(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: theme.forgeColors.onImmersiveMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
