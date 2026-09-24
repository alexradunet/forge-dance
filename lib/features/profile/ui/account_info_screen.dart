import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../extensions/string_extension.dart';
import '../../../design_system/design_system.dart';
import '../../../utils/global_loading.dart';
import '../model/profile.dart';
import '../repository/device_avatar_repository.dart';
import 'view_model/profile_view_model.dart';
import 'widgets/avatar.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  final Profile originalProfile;

  const AccountInfoScreen({super.key, required this.originalProfile});

  @override
  ConsumerState createState() => _AccountInfoScreenState();
}

class _AccountInfoScreenState extends ConsumerState<AccountInfoScreen> {
  late final TextEditingController nameController;
  String? avatar;
  String? name;
  String? _error;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.originalProfile.name);
    avatar = widget.originalProfile.avatar;
    name = widget.originalProfile.name;

    nameController.addListener(_updateName);
    _loadDeviceAvatar();
  }

  Future<void> _loadDeviceAvatar() async {
    try {
      final identity = widget.originalProfile.id ?? 'local-development';
      final saved = await ref
          .read(deviceAvatarRepositoryProvider)
          .load(identity);
      if (mounted && saved != null) setState(() => avatar = saved);
    } catch (error) {
      if (mounted) setState(() => _error = error.toString());
    }
  }

  Future<void> _selectImage() async {
    if (_saving) return;
    try {
      final identity = widget.originalProfile.id ?? 'local-development';
      final result = await ref
          .read(deviceAvatarRepositoryProvider)
          .selectAndSave(identity);
      if (mounted && result != null) setState(() => avatar = result);
    } catch (error) {
      if (mounted) {
        setState(() => _error = error.toString());
        context.showErrorSnackBar(error.toString());
      }
    }
  }

  void _updateName() {
    setState(() => name = nameController.text);
  }

  @override
  void dispose() {
    nameController.removeListener(_updateName);
    nameController.dispose();
    super.dispose();
  }

  bool get _canSave =>
      !_saving &&
      (name?.trim().isNotEmpty ?? false) &&
      (avatar != widget.originalProfile.avatar ||
          name != widget.originalProfile.name);

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: FgImmersiveScaffold(
      title: LocaleKeys.accountInformation.tr(),
      onBack: () {
        if (!_saving) context.pop();
      },
      bodyBuilder: (context) => FgReadingBody(
        child: ListView(
          padding: AppSpacing.allXXL,
          children: [
            FgSectionHeading(
              eyebrow: LocaleKeys.personalLocalIdentity.tr(),
              title: LocaleKeys.setUpYourProfile.tr(),
              subtitle: LocaleKeys.personalAccountIntro.tr(),
            ),
            const SizedBox(height: AppSpacing.xxl),
            FgCard(
              immersive: true,
              shape: FgCardShape.editorial,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: AppSpacing.lg,
                    runSpacing: AppSpacing.lg,
                    children: [
                      Avatar(
                        url: avatar ?? widget.originalProfile.avatar,
                        semanticLabel: name ?? widget.originalProfile.name,
                      ),
                      FgButton(
                        text: LocaleKeys.selectAvatar.tr(),
                        variant: FgButtonVariant.secondary,
                        onPressed: _saving ? null : _selectImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  if (widget.originalProfile.email.orEmpty().isNotEmpty) ...[
                    FgLabel(text: LocaleKeys.email.tr()),
                    const SizedBox(height: AppSpacing.sm),
                    Text(widget.originalProfile.email.orEmpty()),
                    const SizedBox(height: AppSpacing.xxl),
                  ],
                  FgInput(
                    label: LocaleKeys.name.tr(),
                    controller: nameController,
                    isRequired: true,
                    isEnabled: !_saving,
                    errorText: name?.trim().isEmpty == true
                        ? LocaleKeys.personalNameRequired.tr()
                        : null,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) {
                      if (_canSave) _save(context);
                    },
                  ),
                  if (_error != null) ...[
                    const SizedBox(height: AppSpacing.lg),
                    Semantics(
                      liveRegion: true,
                      child: Text(
                        _error!,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: AppSpacing.xxl),
                  FgButton(
                    text: LocaleKeys.confirm.tr(),
                    expand: true,
                    isLoading: _saving,
                    onPressed: _canSave ? () => _save(context) : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );

  Future<void> _save(BuildContext context) async {
    if (!_canSave) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      Global.showLoading(context);
      await ref.read(profileViewModelProvider.notifier).editProfile(name: name);
      if (ref.read(profileViewModelProvider).hasError) {
        throw StateError('Profile save failed');
      }
      if (context.mounted) context.pop();
    } catch (_) {
      if (context.mounted) {
        setState(() => _error = LocaleKeys.unexpectedErrorOccurred.tr());
        context.showErrorSnackBar(_error!);
      }
    } finally {
      Global.hideLoading();
      if (mounted) setState(() => _saving = false);
    }
  }
}
