import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../../constants/assets.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import '../../../features/authentication/ui/widgets/horizontal_divider.dart';
import '../../../features/authentication/ui/widgets/social_sign_in.dart';
import '../../../design_system/atoms/buttons/app_button.dart';
import '../../../design_system/atoms/inputs/app_input.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../routing/routes.dart';
import '../../../design_system/tokens/app_typography.dart';
import '../../../utils/validator.dart';

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
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: SvgPicture.asset(
                      Assets.login,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                      semanticsLabel: 'Sign in',
                    ),
                  ),
                  Text(
                    LocaleKeys.signIn.tr(),
                    style: AppTypography.h1.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  AppInput(
                    label: 'Email',
                    controller: _emailController,
                  ),
                  const SizedBox(height: 32),
                  AppButton(
                    onPressed: _isEmailValid
                        ? () {
                            ref
                                .read(authenticationViewModelProvider.notifier)
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
                  const SizedBox(height: 16),
                  const HorizontalDivider(),
                  const SizedBox(height: 16),
                  const SocialSignIn(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: AppHeader(
                title: '',
                onBack: () => context.pop(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
