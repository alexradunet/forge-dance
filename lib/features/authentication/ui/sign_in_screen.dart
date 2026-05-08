import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../design_system/atoms/buttons/fg_button.dart';
import '../../../design_system/atoms/inputs/fg_input.dart';
import '../../../design_system/atoms/visuals/fg_background.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../../utils/global_loading.dart';
import '../../../utils/validator.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  bool _isFormValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController()..addListener(_validateForm);
    _passwordController = TextEditingController()..addListener(_validateForm);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateForm);
    _passwordController.removeListener(_validateForm);
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _validateForm() {
    setState(() {
      _isFormValid = isValidEmail(_emailController.text) &&
          _passwordController.text.trim().length >= 6;
    });
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
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: 'WELCOME BACK',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 200,
                      child: SvgPicture.asset(
                        Assets.login,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        semanticsLabel: 'Sign in',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      LocaleKeys.signIn.tr(),
                      style: AppTypography.h1.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    FgInput(
                      label: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 16),
                    FgInput.password(
                      controller: _passwordController,
                    ),
                    const SizedBox(height: 32),
                    FgButton(
                      onPressed: _isFormValid
                          ? () => ref
                              .read(authenticationViewModelProvider.notifier)
                              .signInWithEmailAndPassword(
                                email: _emailController.text,
                                password: _passwordController.text,
                              )
                          : null,
                      text: LocaleKeys.signIn.tr(),
                      width: double.infinity,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.doNotHaveAccount.tr(),
                          style: AppTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () => context.push(Routes.register),
                          child: Text(
                            'register'.tr(),
                            style: AppTheme.bodySmall.copyWith(
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
