import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../learn/ui/view_model/learn_view_model.dart';
import '../model/vocabulary_entry.dart';
import '../repository/vocabulary_repository.dart';
import 'vocabulary_page.dart';

class VocabularyEntryPage extends ConsumerWidget {
  const VocabularyEntryPage({
    super.key,
    required this.entry,
    required this.onBack,
  });
  final VocabularyEntry entry;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final canOpenLesson =
        ref
            .watch(learnViewModelProvider)
            .value
            ?.canOpenLesson(entry.lessonId) ??
        false;
    final theme = Theme.of(context);
    return Scaffold(
      body: FgBackground(
        child: ListView(
          children: [
            AppHeader(
              title: entry.name,
              subtitle: '${vocabularyKindLabel(entry.kind)} • ${entry.style}',
              onBack: onBack,
            ),
            Padding(
              padding: AppSpacing.screen,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    entry.definition,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.forgeColors.onImmersive,
                    ),
                  ),
                  if (entry.aliases.isNotEmpty) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      LocaleKeys.vocabularyAlsoKnown.tr(
                        args: [entry.aliases.join(', ')],
                      ),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.forgeColors.onImmersiveMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  _section(context, LocaleKeys.vocabularyCue.tr(), entry.cue),
                  _section(
                    context,
                    LocaleKeys.vocabularyMistake.tr(),
                    entry.commonMistake,
                  ),
                  _section(
                    context,
                    LocaleKeys.vocabularyPractice.tr(),
                    entry.practice,
                  ),
                  Text(
                    LocaleKeys.vocabularyComfort.tr(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.forgeColors.onImmersiveMuted,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FgButton(
                    text: canOpenLesson
                        ? LocaleKeys.vocabularyViewLesson.tr()
                        : LocaleKeys.vocabularyViewPath.tr(),
                    onPressed: () {
                      if (canOpenLesson) {
                        LessonDestination(
                          entry.moduleId,
                          entry.lessonId,
                        ).push<void>(context);
                      } else {
                        ModuleDestination(entry.moduleId).push<void>(context);
                      }
                    },
                  ),
                  if (!canOpenLesson) ...[
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      LocaleKeys.vocabularyPathHint.tr(),
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.forgeColors.onImmersiveMuted,
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xl),
                  Text(
                    LocaleKeys.vocabularyRelated.tr(),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.forgeColors.onImmersive,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  for (final id in entry.relatedIds)
                    if (const VocabularyRepository().byId(id)
                        case final related?)
                      FgButton(
                        text: related.name,
                        variant: FgButtonVariant.secondary,
                        onPressed: () =>
                            VocabularyDestination(id).push<void>(context),
                      ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(BuildContext context, String title, String body) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: FgCard(
        immersive: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.forgeColors.onImmersive,
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              body,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.forgeColors.onImmersiveMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
