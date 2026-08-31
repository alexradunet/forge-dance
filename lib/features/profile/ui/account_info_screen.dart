import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../extensions/string_extension.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../utils/global_loading.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import '../../common/ui/widgets/common_text_form_field.dart';
import '../../common/ui/widgets/primary_button.dart';
import '../../common/ui/widgets/secondary_button.dart';
import '../model/profile.dart';
import '../repository/device_avatar_repository.dart';
import 'view_model/profile_view_model.dart';
import 'widgets/avatar.dart';

class AccountInfoScreen extends ConsumerStatefulWidget {
  final Profile originalProfile;

  const AccountInfoScreen({
    super.key,
    required this.originalProfile,
  });

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
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.accountInformation.tr(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Avatar(url: avatar ?? widget.originalProfile.avatar),
                      const SizedBox(width: 16),
                      SizedBox(
                        width: 120,
                        child: SecondaryButton(
                          text: LocaleKeys.selectAvatar.tr(),
                          onPressed: _selectImage,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  Text(LocaleKeys.email.tr(), style: AppTypography.caption),
                  const SizedBox(height: 6),
                  Text(
                    widget.originalProfile.email.orEmpty(),
                    style: AppTypography.body,
                  ),
                  const SizedBox(height: 32),
                  CommonTextFormField(
                    label: LocaleKeys.name.tr(),
                    controller: nameController,
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 24,
                right: 24,
                bottom: 32,
              ),
              child: PrimaryButton(
                text: LocaleKeys.confirm.tr(),
                isEnable: avatar != widget.originalProfile.avatar ||
                    name != widget.originalProfile.name,
                onPressed: () async {
                  try {
                    Global.showLoading(context);
                    await ref
                        .read(profileViewModelProvider.notifier)
                        .editProfile(
                          name: name,
                        );
                    if (context.mounted) {
                      context.pop();
                    }
                  } catch (error) {
                    if (context.mounted) {
                      context.showErrorSnackBar(
                          LocaleKeys.unexpectedErrorOccurred.tr());
                    }
                  } finally {
                    Global.hideLoading();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
