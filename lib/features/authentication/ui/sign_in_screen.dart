import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import '../../../design_system/atoms/buttons/fg_button.dart';
import '../../../design_system/atoms/inputs/fg_input.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../utils/validator.dart';

import '../../../design_system/atoms/visuals/fg_background.dart';

class SignInScreen extends ConsumerStatefulWidget {
  const SignInScreen({super.key});

  @override
  ConsumerState createState() => _SignInScreenState();
}

class _SignInScreenState extends ConsumerState<SignInScreen> {
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
                                  'isRegister': false,
                                },
                              );
                            }
                          : null,
                      text: LocaleKeys.continueText.tr(),
                      width: double.infinity,
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
