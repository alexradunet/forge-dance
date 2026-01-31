import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:pinput/pinput.dart';

import '../../../constants/assets.dart';
import '../../../extensions/build_context_extension.dart';
import '../../../features/authentication/ui/view_model/authentication_view_model.dart';
import 'package:go_router/go_router.dart';
import '../../../design_system/tokens/app_colors.dart';
import '../../../design_system/atoms/buttons/app_button.dart';
import '../../../design_system/organisms/navigation/app_header.dart';
import '../../../generated/locale_keys.g.dart';
import '../../../design_system/tokens/app_typography.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String email;
  final bool isRegister;

  const OtpScreen({
    super.key,
    required this.email,
    required this.isRegister,
  });

  @override
  ConsumerState createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  late final TextEditingController otpController;
  late Timer _timer;
  int count = 60;
  bool isEnableResendButton = false;

  @override
  void initState() {
    super.initState();
    otpController = TextEditingController();
    startTimer();
  }

  @override
  void dispose() {
    otpController.dispose();
    _timer.cancel();
    super.dispose();
  }

  void startTimer() {
    isEnableResendButton = false;
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (count == 0) {
          count = 60;
          isEnableResendButton = true;
          timer.cancel();
        } else {
          count--;
        }
      });
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
                      Assets.otp,
                      fit: BoxFit.fitWidth,
                      alignment: Alignment.bottomCenter,
                      semanticsLabel: 'OTP',
                    ),
                  ),
                  Text(
                    LocaleKeys.otpEnterTitle.tr(),
                    style: AppTypography.h5.copyWith(color: Colors.white),
                  ),
                  Text(
                    LocaleKeys.otpEnterDescription.tr(),
                    style:
                        AppTypography.body.copyWith(color: AppColors.textMuted),
                  ),
                  const SizedBox(height: 16),
                  Center(
                    child: Pinput(
                      length: 6,
                      controller: otpController,
                      defaultPinTheme: PinTheme(
                        width: 48,
                        height: 48,
                        textStyle: AppTypography.body,
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.neutral700),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        LocaleKeys.didNotReceiveOtp.tr(),
                        style: AppTypography.bodySmall.copyWith(
                          color: AppColors.textMuted,
                        ),
                      ),
                      TextButton(
                        onPressed: isEnableResendButton
                            ? () async {
                                otpController.clear();
                                await ref
                                    .read(authenticationViewModelProvider
                                        .notifier)
                                    .signInWithMagicLink(widget.email);
                                startTimer();
                              }
                            : null,
                        child: Text(
                          LocaleKeys.resendOtp.tr(),
                          style: AppTypography.caption
                              .copyWith(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                  count < 60
                      ? Padding(
                          padding: const EdgeInsets.only(top: 16, bottom: 32),
                          child: Text(
                            LocaleKeys.tryAgainAfter,
                            style: AppTypography.bodySmall.copyWith(
                              color: AppColors.textMuted,
                            ),
                          ).tr(args: ['$count']),
                        )
                      : const SizedBox(height: 68),
                  AppButton(
                    onPressed: otpController.text.length == 6
                        ? () => ref
                            .read(authenticationViewModelProvider.notifier)
                            .verifyOtp(
                              email: widget.email,
                              token: otpController.text,
                              isRegister: widget.isRegister,
                            )
                        : null,
                    text: LocaleKeys.confirm.tr(),
                    width: double.infinity,
                  ),
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
