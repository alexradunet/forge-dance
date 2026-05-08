import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../constants/constants.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../../utils/global_loading.dart';
import '../../../utils/validator.dart';
import '../../../design_system/atoms/buttons/fg_button.dart';
import '../../../design_system/atoms/inputs/fg_input.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import '../../../features/authentication/ui/widgets/sign_in_agreement.dart';

import '../../../design_system/atoms/visuals/fg_background.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  late final TextEditingController _emailController;
  bool _isEmailValid = false;

  @override
  void initState() {
    super.initState();
    _emailController = TextEditingController();
    _emailController.addListener(_validateEmail);
  }

  @override
  void dispose() {
    _emailController.removeListener(_validateEmail);
    _emailController.dispose();
    super.dispose();
  }

  void _validateEmail() {
    setState(() {
      _isEmailValid = isValidEmail(_emailController.text);
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

      if (next is AsyncData) {
        debugPrint(
            '${Constants.tag} [RegisterScreen.build] isRegisterSuccessfully = ${next.value?.isRegisterSuccessfully}, isSignInSuccessfully = ${next.value?.isSignInSuccessfully}');
        if (next.value?.isRegisterSuccessfully == true) {
          context.pushReplacement(Routes.onboarding);
        } else if (next.value?.isSignInSuccessfully == true) {
          context.pushReplacement(Routes.main);
        }
      }
    });

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: 'JOIN THE FORGE',
              subtitle: 'Start your rhythm journey',
              onBack: context.canPop() ? () => context.pop() : null,
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
                        Assets.welcome,
                        fit: BoxFit.contain,
                        alignment: Alignment.center,
                        semanticsLabel: 'Welcome',
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'register'.tr(),
                      style: AppTypography.h1.copyWith(color: Colors.white),
                    ),
                    const SizedBox(height: 24),
                    FgInput(
                      label: 'Email',
                      controller: _emailController,
                    ),
                    const SizedBox(height: 32),
                    FgButton(
                      onPressed: _isEmailValid
                          ? () {
                              ref
                                  .read(
                                      authenticationViewModelProvider.notifier)
                                  .signInWithMagicLink(_emailController.text);
                              context.push(
                                Routes.otp,
                                extra: {
                                  'email': _emailController.text,
                                  'isRegister': true,
                                },
                              );
                            }
                          : null,
                      text: LocaleKeys.continueText.tr(),
                      width: double.infinity,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          LocaleKeys.alreadyHaveAccount.tr(),
                          style: AppTheme.bodySmall,
                        ),
                        const SizedBox(width: 4),
                        TextButton(
                          onPressed: () {
                            context.push(Routes.login);
                          },
                          child: Text(
                            LocaleKeys.signIn.tr(),
                            style: AppTheme.bodySmall
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const SignInAgreement(),
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
