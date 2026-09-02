import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../extensions/build_context_extension.dart';
import '../../../design_system/design_system.dart';
import '../../../features/profile/ui/view_model/profile_view_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';

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
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.gettingStarted.tr().toUpperCase(),
              subtitle: LocaleKeys.setUpYourProfile.tr(),
            ),
            Expanded(
              child: Padding(
                padding: AppSpacing.allXXL,
                child: Column(
                  children: [
                    const SizedBox(height: AppSpacing.xxl),
                    FgAvatar.large(
                      initials: _nameController.text.trim().isEmpty
                          ? null
                          : _nameController.text.trim().characters.first,
                    ),
                    const SizedBox(height: AppSpacing.xxxl),
                    FgInput(
                      key: const ValueKey('onboarding.name'),
                      label: LocaleKeys.yourName.tr(),
                      controller: _nameController,
                      isRequired: true,
                      textCapitalization: TextCapitalization.words,
                      textInputAction: TextInputAction.done,
                    ),
                    const Spacer(),
                    FgButton(
                      key: const ValueKey('onboarding.continue'),
                      text: LocaleKeys.continueText.tr(),
                      expand: true,
                      onPressed: _isButtonEnabled
                          ? () => _saveNameAndContinue(context)
                          : null,
                    ),
                    const SizedBox(height: AppSpacing.lg),
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
      await ref
          .read(profileViewModelProvider.notifier)
          .editProfile(name: _nameController.text.trim());
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
