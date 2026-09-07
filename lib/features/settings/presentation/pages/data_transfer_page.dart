import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../design_system/design_system.dart';
import '../../../../generated/locale_keys.g.dart';
import '../view_model/data_transfer_view_model.dart';

class DataTransferPage extends ConsumerStatefulWidget {
  const DataTransferPage({super.key});
  @override
  ConsumerState<DataTransferPage> createState() => _DataTransferPageState();
}

class _DataTransferPageState extends ConsumerState<DataTransferPage> {
  String? _message;
  final _exportKey = GlobalKey();

  Future<void> _export() async {
    try {
      final box = _exportKey.currentContext!.findRenderObject()! as RenderBox;
      await ref
          .read(dataTransferViewModelProvider.notifier)
          .exportBackup(box.localToGlobal(Offset.zero) & box.size);
      if (mounted) {
        setState(() => _message = LocaleKeys.forgeExportSuccess.tr());
      }
    } catch (_) {
      // The notifier exposes the actionable transfer error below the controls.
    }
  }

  Future<void> _restore() async {
    try {
      final backup = await ref
          .read(dataTransferViewModelProvider.notifier)
          .prepareRestore();
      if (backup == null || !mounted) return;
      final confirmed = await FgImmersiveScaffold.showModal<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(LocaleKeys.forgeRestoreConfirm.tr()),
          content: Text(LocaleKeys.forgeRestoreWarning.tr()),
          actions: [
            FgButton(
              text: LocaleKeys.cancel.tr(),
              variant: FgButtonVariant.ghost,
              onPressed: () => Navigator.pop(context, false),
            ),
            FgButton(
              text: LocaleKeys.forgeRestoreAction.tr(),
              variant: FgButtonVariant.destructive,
              onPressed: () => Navigator.pop(context, true),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
      await ref.read(dataTransferViewModelProvider.notifier).restore(backup);
      if (mounted) {
        setState(() => _message = LocaleKeys.forgeTransferSuccess.tr());
      }
    } catch (_) {
      // Validation and IO failures are retained in the view model.
    }
  }

  @override
  Widget build(BuildContext context) {
    final transfer = ref.watch(dataTransferViewModelProvider);
    final busy = transfer.isLoading;
    return PopScope(
      canPop: !busy,
      child: FgImmersiveScaffold(
        bodyBuilder: (context) => CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: AppHeader(
                title: LocaleKeys.forgeTransferTitle.tr(),
                onBack: busy ? null : () => Navigator.of(context).pop(),
              ),
            ),
            SliverPadding(
              padding: AppSpacing.allXXL,
              sliver: SliverToBoxAdapter(
                child: FgCard(
                  immersive: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(LocaleKeys.forgeTransferDescription.tr()),
                      const SizedBox(height: AppSpacing.xxl),
                      FgButton(
                        key: _exportKey,
                        text: LocaleKeys.forgeExportData.tr(),
                        expand: true,
                        onPressed: busy ? null : _export,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      FgButton(
                        text: LocaleKeys.forgeImportData.tr(),
                        variant: FgButtonVariant.secondary,
                        expand: true,
                        onPressed: busy ? null : _restore,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      Text(LocaleKeys.forgeRestoreWarning.tr()),
                      if (busy)
                        const Padding(
                          padding: AppSpacing.allLG,
                          child: Center(child: FgSpinner()),
                        ),
                      if (transfer.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                          ),
                          child: Text(
                            LocaleKeys.forgeTransferError.tr(
                              args: ['${transfer.error}'],
                            ),
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                          ),
                        ),
                      if (_message != null && !transfer.hasError)
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppSpacing.lg,
                          ),
                          child: Text(_message!),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
