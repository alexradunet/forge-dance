import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../features/common/ui/widgets/common_text_form_field.dart';
import '../../../features/common/ui/widgets/primary_button.dart';
import '../../../features/profile/ui/view_model/profile_view_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';

import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';

class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final TextEditingController _nameController = TextEditingController();
  bool _isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateButtonState);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateButtonState);
    _nameController.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    final isEnabled = _nameController.text.trim().isNotEmpty;
    if (isEnabled != _isButtonEnabled) {
      setState(() {
        _isButtonEnabled = isEnabled;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.gettingStarted.tr().toUpperCase(),
              subtitle: LocaleKeys.setUpYourProfile.tr(),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    GestureDetector(
                      onTap: () {
                        // TODO: Implement image picker
                      },
                      child: CircleAvatar(
                        radius: 50,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(
                          Icons.camera_alt,
                          size: 40,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    CommonTextFormField(
                      label: LocaleKeys.yourName.tr(),
                      controller: _nameController,
                    ),
                    const Spacer(),
                    PrimaryButton(
                      text: LocaleKeys.continueText.tr(),
                      onPressed: () => _saveNameAndContinue(context),
                      isEnable: _isButtonEnabled,
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveNameAndContinue(BuildContext context) async {
    try {
      await ref.read(profileViewModelProvider.notifier).updateProfile(
            name: _nameController.text.trim(),
          );
      if (context.mounted) {
        context.pushReplacement(Routes.main);
      }
    } catch (error) {
      if (context.mounted) {
        context.showErrorSnackBar(LocaleKeys.failedToSaveProfile.tr());
      }
    }
  }
}
