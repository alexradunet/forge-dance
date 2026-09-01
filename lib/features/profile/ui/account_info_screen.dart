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
    final identity = widget.originalProfile.id ?? 'local-development';
    final saved = await ref.read(deviceAvatarRepositoryProvider).load(identity);
    if (mounted && saved != null) setState(() => avatar = saved);
  }

  Future<void> _selectImage() async {
    try {
      final identity = widget.originalProfile.id ?? 'local-development';
      final result = await ref
          .read(deviceAvatarRepositoryProvider)
          .selectAndSave(identity);
      if (mounted && result != null) setState(() => avatar = result);
    } catch (error) {
      if (mounted) context.showErrorSnackBar(error.toString());
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.accountInformation.tr(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  vertical: AppSpacing.xxxl,
                  horizontal: AppSpacing.xxl,
                ),
                children: [
                  Wrap(
                    alignment: WrapAlignment.center,
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
                        size: FgButtonSize.sm,
                        onPressed: _selectImage,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  FgLabel(text: LocaleKeys.email.tr()),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    widget.originalProfile.email.orEmpty(),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).forgeColors.onImmersive,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxxl),
                  FgInput(
                    label: LocaleKeys.name.tr(),
                    controller: nameController,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: AppSpacing.xxl,
                right: AppSpacing.xxl,
                bottom: AppSpacing.xxxl,
              ),
              child: FgButton(
                text: LocaleKeys.confirm.tr(),
                expand: true,
                onPressed:
                    avatar != widget.originalProfile.avatar ||
                        name != widget.originalProfile.name
                    ? () async {
                        try {
                          Global.showLoading(context);
                          await ref
                              .read(profileViewModelProvider.notifier)
                              .editProfile(name: name);
                          if (context.mounted) {
                            context.pop();
                          }
                        } catch (error) {
                          if (context.mounted) {
                            context.showErrorSnackBar(
                              LocaleKeys.unexpectedErrorOccurred.tr(),
                            );
                          }
                        } finally {
                          Global.hideLoading();
                        }
                      }
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
