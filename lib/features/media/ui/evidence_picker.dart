import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../design_system/design_system.dart';
import '../../../generated/locale_keys.g.dart';
import '../model/local_media.dart';
import '../repository/media_repository.dart';
import 'local_video_view.dart';

class EvidencePicker extends ConsumerStatefulWidget {
  const EvidencePicker({
    super.key,
    this.value,
    required this.onChanged,
    this.isReadOnly = false,
  });
  final bool isReadOnly;
  final String? value;
  final ValueChanged<String?> onChanged;
  @override
  ConsumerState<EvidencePicker> createState() => _EvidencePickerState();
}

class _EvidencePickerState extends ConsumerState<EvidencePicker> {
  bool _busy = false;
  String? _error;

  Future<void> _import() async {
    if (widget.isReadOnly || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final item = await ref.read(mediaRepositoryProvider).pickAndImportVideo();
      if (mounted && !widget.isReadOnly && item != null) {
        widget.onChanged(item.id);
      }
    } catch (error) {
      if (mounted) setState(() => _error = mediaErrorText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _choose() async {
    if (widget.isReadOnly || _busy) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final items = await ref.read(mediaRepositoryProvider).getAll();
      if (!mounted) return;
      final selected = await FgImmersiveScaffold.showModal<LocalMedia>(
        context: context,
        builder: (context) => SimpleDialog(
          title: Text(LocaleKeys.mediaLibrary.tr()),
          children: items.isEmpty
              ? [
                  Padding(
                    padding: AppSpacing.allLG,
                    child: Text(LocaleKeys.mediaLibraryEmpty.tr()),
                  ),
                ]
              : items
                    .map(
                      (item) => SimpleDialogOption(
                        onPressed: () => Navigator.pop(context, item),
                        child: Text(item.title),
                      ),
                    )
                    .toList(),
        ),
      );
      if (mounted && !widget.isReadOnly && selected != null) {
        widget.onChanged(selected.id);
      }
    } catch (error) {
      if (mounted) setState(() => _error = mediaErrorText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _delete() async {
    if (widget.isReadOnly || _busy) return;
    final id = widget.value;
    if (id == null) return;
    final confirmed = await FgImmersiveScaffold.showModal<bool>(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        title: Text(LocaleKeys.mediaDelete.tr()),
        content: Text(LocaleKeys.mediaDeleteConfirm.tr()),
        actions: [
          FgButton(
            text: LocaleKeys.mediaCancel.tr(),
            variant: FgButtonVariant.ghost,
            onPressed: () => Navigator.pop(context, false),
          ),
          FgButton(
            text: LocaleKeys.mediaDelete.tr(),
            variant: FgButtonVariant.destructive,
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted || widget.isReadOnly) return;
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await ref.read(mediaRepositoryProvider).delete(id);
      if (mounted) widget.onChanged(null);
    } catch (error) {
      if (mounted) setState(() => _error = mediaErrorText(error));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => FgCard(
    immersive: true,
    shape: FgCardShape.editorial,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            FgButton(
              text: LocaleKeys.mediaImport.tr(),
              icon: const Icon(Icons.video_library_outlined),
              isLoading: _busy,
              isEnabled: !widget.isReadOnly,
              onPressed: _import,
            ),
            FgButton(
              text: LocaleKeys.mediaLibrary.tr(),
              variant: FgButtonVariant.secondary,
              isEnabled: !_busy && !widget.isReadOnly,
              onPressed: _choose,
            ),
            if (widget.value != null) ...[
              FgButton(
                isEnabled: !_busy,
                text: LocaleKeys.mediaView.tr(),
                variant: FgButtonVariant.secondary,
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).push<void>(
                      MaterialPageRoute(
                        builder: (_) =>
                            EvidenceViewer(evidenceId: widget.value!),
                      ),
                    ),
              ),
              FgButton(
                isEnabled: !_busy && !widget.isReadOnly,
                text: LocaleKeys.mediaUnlink.tr(),
                variant: FgButtonVariant.ghost,
                onPressed: () => widget.onChanged(null),
              ),
              FgButton(
                text: LocaleKeys.mediaDelete.tr(),
                variant: FgButtonVariant.destructive,
                isEnabled: !_busy && !widget.isReadOnly,
                onPressed: _delete,
              ),
            ],
          ],
        ),
        if (widget.value != null)
          FutureBuilder<LocalMedia?>(
            future: ref.read(mediaRepositoryProvider).get(widget.value!),
            builder: (context, snapshot) => Text(
              snapshot.hasError
                  ? mediaErrorText(snapshot.error!)
                  : snapshot.connectionState == ConnectionState.done
                  ? snapshot.data?.title ?? LocaleKeys.mediaMissing.tr()
                  : LocaleKeys.mediaLoading.tr(),
            ),
          ),
        if (_error != null)
          Semantics(
            liveRegion: true,
            child: Text(
              _error!,
              style: Theme.of(context).textTheme.bodyMedium
                  ?.copyWith(color: Theme.of(context).colorScheme.error),
            ),
          ),
        FgDetails(
          title: LocaleKeys.detailsPrivacy.tr(),
          child: Text(LocaleKeys.mediaPrivacy.tr()),
        ),
      ],
    ),
  );
}

String mediaErrorText(Object error) {
  if (error is MediaImportException) {
    return switch (error.reason) {
      'size' => LocaleKeys.mediaSizeError.tr(),
      'quota' => LocaleKeys.mediaQuotaError.tr(),
      'unsupported' => LocaleKeys.mediaUnsupported.tr(),
      'missing' => LocaleKeys.mediaMissing.tr(),
      _ => LocaleKeys.mediaStorageError.tr(),
    };
  }
  return LocaleKeys.mediaStorageError.tr();
}

class EvidenceViewer extends StatelessWidget {
  const EvidenceViewer({super.key, required this.evidenceId});
  final String evidenceId;
  @override
  Widget build(BuildContext context) => FgImmersiveScaffold(
    title: LocaleKeys.mediaView.tr(),
    bodyBuilder: (context) => FgReadingBody(
      child: ListView(
        padding: AppSpacing.allLG,
        children: [
          Text(LocaleKeys.mediaNotVerified.tr()),
          const SizedBox(height: AppSpacing.lg),
          LocalVideoView(evidenceId: evidenceId),
        ],
      ),
    ),
  );
}
