import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../../media/ui/evidence_picker.dart';
import '../model/practice.dart';
import 'practice_view_model.dart';

class PracticeLogPage extends ConsumerStatefulWidget {
  const PracticeLogPage({super.key, this.vocabularyId, this.lessonId});

  final String? vocabularyId;
  final String? lessonId;

  @override
  ConsumerState<PracticeLogPage> createState() => _PracticeLogPageState();
}

class _PracticeLogPageState extends ConsumerState<PracticeLogPage> {
  bool _busy = false;
  String? _error;

  Future<void> _delete(PracticeRecord record) async {
    if (_busy) return;
    final confirmed = await FgImmersiveScaffold.showModal<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(LocaleKeys.practiceDeleteTitle.tr()),
        content: Text(LocaleKeys.practiceDeleteBody.tr()),
        actions: [
          FgButton(
            text: LocaleKeys.practiceCancel.tr(),
            variant: FgButtonVariant.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
          FgButton(
            text: LocaleKeys.practiceDelete.tr(),
            variant: FgButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(practiceViewModelProvider.notifier).delete(record.id);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = LocaleKeys.practiceSaveFailed.tr(args: ['$error']),
        );
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final history = ref.watch(practiceViewModelProvider);
    final records = <PracticeRecord>[
      ...?history.value?.where(
        (record) =>
            (widget.vocabularyId == null ||
                record.vocabularyId == widget.vocabularyId) &&
            (widget.lessonId == null || record.lessonId == widget.lessonId),
      ),
    ]..sort((a, b) => b.performedAt.compareTo(a.performedAt));
    return FgImmersiveScaffold(
      title: LocaleKeys.practiceLogTitle.tr(),
      bodyBuilder: (context) => ListView(
        padding: AppSpacing.allLG,
        children: [
          Text(LocaleKeys.practiceLogIntro.tr()),
          if (widget.lessonId != null || widget.vocabularyId != null)
            Text(LocaleKeys.practiceFilteredHistory.tr()),
          const SizedBox(height: AppSpacing.lg),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          if (history.isLoading)
            const Center(child: FgSpinner())
          else if (history.hasError) ...[
            Text(LocaleKeys.practiceLoadFailed.tr(args: ['${history.error}'])),
            FgButton(
              text: LocaleKeys.practiceRetry.tr(),
              onPressed: () =>
                  ref.read(practiceViewModelProvider.notifier).reload(),
            ),
          ] else if (records.isEmpty)
            FgEmpty(
              icon: Icons.history,
              title: LocaleKeys.practiceLogEmpty.tr(),
            )
          else
            for (var index = 0; index < records.length; index++) ...[
              _recordCard(
                context,
                records[index],
                records
                    .skip(index + 1)
                    .where(records[index].isComparableTo)
                    .firstOrNull,
              ),
              const SizedBox(height: AppSpacing.lg),
            ],
        ],
      ),
    );
  }

  Widget _recordCard(
    BuildContext context,
    PracticeRecord record,
    PracticeRecord? previous,
  ) => FgCard(
    immersive: true,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(record.title, style: Theme.of(context).textTheme.titleMedium),
        Text(
          DateFormat.yMMMd(context.locale.toString())
              .add_jm()
              .format(record.performedAt.toLocal()),
        ),
        Text(
          LocaleKeys.practiceRecordedMetrics.tr(
            args: [
              '${record.level}',
              '${record.durationSeconds}',
              '${record.bpm}',
              '${record.attempts}',
              '${record.difficulty}',
            ],
          ),
        ),
        if (record.notes.isNotEmpty) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(record.notes),
        ],
        const SizedBox(height: AppSpacing.sm),
        if (previous == null)
          Text(LocaleKeys.practiceNoComparable.tr())
        else ...[
          Text(
            LocaleKeys.practiceComparedWith.tr(
              args: [
                DateFormat.yMMMd(context.locale.toString())
                    .add_jm()
                    .format(previous.performedAt.toLocal()),
              ],
            ),
          ),
          Text(
            LocaleKeys.practiceComparison.tr(
              args: [
                _signed(record.durationSeconds - previous.durationSeconds),
                _signed(record.attempts - previous.attempts),
                _signed(record.difficulty - previous.difficulty),
              ],
            ),
          ),
        ],
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FgButton(
              text: LocaleKeys.practiceEditReflection.tr(),
              variant: FgButtonVariant.secondary,
              onPressed: _busy
                  ? null
                  : () => Navigator.of(context).push<void>(
                      MaterialPageRoute(
                        builder: (_) => _PracticeReflectionPage(record: record),
                      ),
                    ),
            ),
            if (record.evidenceId != null)
              FgButton(
                text: LocaleKeys.practiceViewEvidence.tr(),
                variant: FgButtonVariant.secondary,
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            EvidenceViewer(evidenceId: record.evidenceId!),
                      ),
                    ),
              ),
            FgButton(
              text: LocaleKeys.practiceDelete.tr(),
              variant: FgButtonVariant.ghost,
              onPressed: _busy ? null : () => _delete(record),
            ),
          ],
        ),
      ],
    ),
  );

  String _signed(int value) => value > 0 ? '+$value' : '$value';
}

class _PracticeReflectionPage extends ConsumerStatefulWidget {
  const _PracticeReflectionPage({required this.record});
  final PracticeRecord record;

  @override
  ConsumerState<_PracticeReflectionPage> createState() =>
      _PracticeReflectionPageState();
}

class _PracticeReflectionPageState
    extends ConsumerState<_PracticeReflectionPage> {
  late final TextEditingController _notes;
  late final TextEditingController _effort;
  String? _evidenceId;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _notes = TextEditingController(text: widget.record.notes);
    _effort = TextEditingController(text: '${widget.record.difficulty}');
    _evidenceId = widget.record.evidenceId;
  }

  @override
  void dispose() {
    _notes.dispose();
    _effort.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    final effort = int.tryParse(_effort.text.trim());
    if (effort == null ||
        effort < 1 ||
        effort > 10 ||
        _notes.text.length > 10000) {
      setState(() => _error = LocaleKeys.practiceReflectionInvalid.tr());
      return;
    }
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(practiceViewModelProvider.notifier)
          .updateReflection(
            widget.record.withReflection(
              notes: _notes.text.trim(),
              difficulty: effort,
              evidenceId: _evidenceId,
            ),
          );
      if (mounted) Navigator.pop(context);
    } catch (error) {
      if (mounted) {
        setState(
          () => _error = LocaleKeys.practiceSaveFailed.tr(args: ['$error']),
        );
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: FgImmersiveScaffold(
      title: LocaleKeys.practiceEditReflection.tr(),
      bodyBuilder: (context) => ListView(
        padding: AppSpacing.allLG,
        children: [
          Text(
            widget.record.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: AppSpacing.lg),
          FgInput.multiline(
            label: LocaleKeys.practiceNotes.tr(),
            controller: _notes,
            helperText: LocaleKeys.practiceNotesHint.tr(),
            isEnabled: !_saving,
          ),
          const SizedBox(height: AppSpacing.lg),
          FgInput(
            label: LocaleKeys.practiceRpe.tr(),
            controller: _effort,
            keyboardType: TextInputType.number,
            isEnabled: !_saving,
            helperText: LocaleKeys.practiceRpeHint.tr(),
          ),
          const SizedBox(height: AppSpacing.lg),
          IgnorePointer(
            ignoring: _saving,
            child: EvidencePicker(
              value: _evidenceId,
              onChanged: (value) => setState(() => _evidenceId = value),
            ),
          ),
          if (_error != null)
            Text(
              _error!,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
          const SizedBox(height: AppSpacing.lg),
          FgButton(
            text: LocaleKeys.practiceSaveReflection.tr(),
            isLoading: _saving,
            onPressed: _save,
          ),
        ],
      ),
    ),
  );
}
