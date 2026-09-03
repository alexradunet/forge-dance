import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../design_system/design_system.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import '../../../features/authentication/ui/widgets/auth_brand_hero.dart';
import '../../../features/session/application/session_coordinator.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../../utils/global_loading.dart';
import '../../../utils/validator.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final FocusNode _emailFocusNode;
  late final FocusNode _passwordFocusNode;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_validateForm);
    _passwordController = TextEditingController()..addListener(_validateForm);
    _emailFocusNode = FocusNode();
    _passwordFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid =
          isValidEmail(_emailController.text) &&
          _passwordController.text.trim().length >= 6;
    });
  }

  void _submit() {
    if (!_isFormValid) return;
    _passwordFocusNode.unfocus();
    ref
        .read(sessionCoordinatorProvider)
        .signInWithEmailAndPassword(
          email: _emailController.text,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(authenticationViewModelProvider, (previous, next) {
      if (next.isLoading != previous?.isLoading) {
        if (next.isLoading) {
          Global.showLoading(context);
        } else {
          Global.hideLoading();
        }
      }

      if (next is AsyncError) {
        context.showErrorSnackBar(next.error.toString());
      }

      if (next is AsyncData && next.value?.isSignInSuccessfully == true) {
        context.pushReplacement(Routes.main);
      }
    });

    return Scaffold(
      body: Theme(
        data: AppThemes.dark,
        child: FgBackground(
          child: Column(
            children: [
              AppHeader(
                title: LocaleKeys.welcomeBack.tr(),
                onBack: context.canPop() ? () => context.pop() : null,
                rightSlot: const FgLogo(size: AppSizes.iconLg),
              ),
              Expanded(
                child: SingleChildScrollView(
                  padding: AppSpacing.screen,
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 560),
                      child: AutofillGroup(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            AuthBrandHero(message: LocaleKeys.welcomeBack.tr()),
                            const SizedBox(height: AppSpacing.xxxl),
                            Text(
                              LocaleKeys.signIn.tr(),
                              style: AppTypography.h1,
                            ),
                            const SizedBox(height: AppSpacing.xxl),
                            FgInput(
                              key: const ValueKey('sign-in.email'),
                              label: LocaleKeys.email.tr(),
                              controller: _emailController,
                              focusNode: _emailFocusNode,
                              prefixIcon: Icons.mail_outline_rounded,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              autofillHints: const [
                                AutofillHints.username,
                                AutofillHints.email,
                              ],
                              isRequired: true,
                              onSubmitted: (_) =>
                                  _passwordFocusNode.requestFocus(),
                            ),
                            const SizedBox(height: AppSpacing.lg),
                            FgInput.password(
                              key: const ValueKey('sign-in.password'),
                              label: LocaleKeys.password.tr(),
                              controller: _passwordController,
                              focusNode: _passwordFocusNode,
                              textInputAction: TextInputAction.done,
                              autofillHints: const [AutofillHints.password],
                              isRequired: true,
                              showPasswordSemanticsLabel: LocaleKeys
                                  .showPassword
                                  .tr(),
                              hidePasswordSemanticsLabel: LocaleKeys
                                  .hidePassword
                                  .tr(),
                              onSubmitted: (_) => _submit(),
                            ),
                            const SizedBox(height: AppSpacing.xxxl),
                            FgButton(
                              key: const ValueKey('sign-in.submit'),
                              onPressed: _isFormValid ? _submit : null,
                              text: LocaleKeys.signIn.tr(),
                              size: FgButtonSize.lg,
                              expand: true,
                            ),
                            const SizedBox(height: AppSpacing.sm),
                            Center(
                              child: Wrap(
                                alignment: WrapAlignment.center,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Text(
                                    LocaleKeys.doNotHaveAccount.tr(),
                                    style: AppTypography.bodySmall,
                                  ),
                                  FgButton(
                                    text: LocaleKeys.register.tr(),
                                    variant: FgButtonVariant.ghost,
                                    size: FgButtonSize.sm,
                                    onPressed: () =>
                                        context.push(Routes.register),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: AppSpacing.xxxl),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
