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
  bool _saving = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _nameController.addListener(_updateName);
  }

  @override
  void dispose() {
    _nameController.removeListener(_updateName);
    _nameController.dispose();
    super.dispose();
  }

  void _updateName() => setState(() {});

  @override
  Widget build(BuildContext context) => PopScope(
    canPop: !_saving,
    child: FgImmersiveScaffold(
      bodyBuilder: (context) => FgReadingBody(
        child: ListView(
          padding: AppSpacing.allXXL,
          children: [
            const SizedBox(height: AppSpacing.xxl),
            FgSectionHeading(
              eyebrow: LocaleKeys.gettingStarted.tr(),
              title: LocaleKeys.personalOnboardingTitle.tr(),
              subtitle: LocaleKeys.personalOnboardingIntro.tr(),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            FgCard(
              immersive: true,
              shape: FgCardShape.editorial,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: FgAvatar.large(
                      initials: _nameController.text.trim().isEmpty
                          ? null
                          : _nameController.text.trim().characters.first,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xxl),
                  FgSectionHeading(title: LocaleKeys.setUpYourProfile.tr()),
                  const SizedBox(height: AppSpacing.lg),
                  FgInput(
                    key: const ValueKey('onboarding.name'),
                    label: LocaleKeys.yourName.tr(),
                    controller: _nameController,
                    isRequired: true,
                    isEnabled: !_saving,
                    textCapitalization: TextCapitalization.words,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) => _saveNameAndContinue(context),
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
                    key: const ValueKey('onboarding.continue'),
                    text: LocaleKeys.continueText.tr(),
                    expand: true,
                    isLoading: _saving,
                    onPressed:
                        !_saving && _nameController.text.trim().isNotEmpty
                        ? () => _saveNameAndContinue(context)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    ),
  );

  Future<void> _saveNameAndContinue(BuildContext context) async {
    if (_saving || _nameController.text.trim().isEmpty) return;
    setState(() {
      _saving = true;
      _error = null;
    });
    try {
      await ref
          .read(profileViewModelProvider.notifier)
          .editProfile(name: _nameController.text.trim());
      // The existing notifier retains failures in state rather than throwing.
      if (ref.read(profileViewModelProvider).hasError) {
        throw StateError('Profile save failed');
      }
      if (context.mounted) context.pushReplacement(Routes.main);
    } catch (_) {
      if (context.mounted) {
        setState(() => _error = LocaleKeys.failedToSaveProfile.tr());
        context.showErrorSnackBar(_error!);
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }
}
