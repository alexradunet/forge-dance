import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../constants/constants.dart';
import '../../../../extensions/build_context_extension.dart';
import '../../../../design_system/atoms/visuals/fg_background.dart';
import '../../../../design_system/organisms/navigation/app_header.dart';
import '../../../../design_system/tokens/app_colors.dart';
import '../../../../features/common/ui/widgets/common_dialog.dart';
import '../../../../features/profile/model/profile.dart';
import '../../../../features/profile/ui/view_model/profile_view_model.dart';
import '../../../../features/profile/ui/widgets/profile_menu.dart';
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';
import '../../../../utils/global_loading.dart';

class SettingsPage extends ConsumerStatefulWidget {
  final Profile? profile;

  const SettingsPage({super.key, this.profile});

  @override
  ConsumerState createState() => _SettingsPageState();
}

class _SettingsPageState extends ConsumerState<SettingsPage> {
  var _version = '';

  @override
  void initState() {
    super.initState();
    _getPackageInfo();
  }

  @override
  Widget build(BuildContext context) {
    // If profile was not passed via extra, we try to watch it from the store
    // This handles deep linking or refresh scenarios better
    final profile = widget.profile ??
        ref.watch(profileViewModelProvider.select((it) => it.value?.profile));

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: 'SETTINGS',
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      const SizedBox(height: 24),
                      _buildSettingsMenu(profile),
                      const SizedBox(height: 48),
                      Center(
                        child: Text(
                          'Version $_version',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.textMuted.withOpacity(0.5),
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(Profile? profile) {
    return Column(
      children: [
        ProfileMenuSection(
          title: 'General',
          items: [
            ProfileMenuItem(
              icon: Icons.person_outline,
              label: LocaleKeys.accountInformation.tr(),
              onTap: () => context.push(
                Routes.accountInformation,
                extra: profile ?? Profile(),
              ),
            ),
            ProfileMenuItem(
              icon: Icons.palette_outlined,
              label: LocaleKeys.appearances.tr(),
              onTap: () => context.push(Routes.appearances),
            ),
            ProfileMenuItem(
              icon: Icons.language,
              label: LocaleKeys.language.tr(),
              onTap: () => context.push(Routes.languages),
            ),
            ProfileMenuItem(
              icon: Icons.diamond_outlined,
              label: 'Go Premium',
              textColor: AppColors.legendGold,
              onTap: () => context.push(Routes.premium),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'Support',
          items: [
            ProfileMenuItem(
              icon: Icons.article_outlined,
              label: LocaleKeys.termOfService.tr(),
              onTap: () => context.tryLaunchUrl(Constants.termOfService),
            ),
            ProfileMenuItem(
              icon: Icons.shield_outlined,
              label: LocaleKeys.privacyPolicy.tr(),
              onTap: () => context.tryLaunchUrl(Constants.privacyPolicy),
            ),
            ProfileMenuItem(
              icon: Icons.star_outline,
              label: LocaleKeys.rateUs.tr(),
              onTap: () => context.tryLaunchUrl(
                Platform.isIOS ? Constants.appStore : Constants.playStore,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        ProfileMenuSection(
          title: 'Account',
          items: [
            ProfileMenuItem(
              icon: Icons.logout,
              label: LocaleKeys.logOut.tr(),
              textColor: AppColors.passionRed,
              showArrow: false,
              onTap: () => _signOut(context),
            ),
            ProfileMenuItem(
              icon: Icons.delete_outline,
              label: LocaleKeys.deleteAccount.tr(),
              textColor: AppColors.passionRed,
              showArrow: false,
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ],
    );
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform().then((info) {
      setState(() {
        _version = info.version;
      });
    }).catchError((error) {
      debugPrint(
          '${Constants.tag} [_SettingsPageState._getPackageInfo] Error: $error');
    });
  }

  void _signOut(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: LocaleKeys.logOutTitle.tr(),
        content: LocaleKeys.logOutMessage.tr(),
        primaryButtonLabel: LocaleKeys.logOut.tr(),
        primaryButtonBackground: AppColors.passionRed,
        secondaryButtonLabel: LocaleKeys.cancel.tr(),
        primaryButtonAction: () async {
          try {
            Global.showLoading(context);
            await ref.read(profileViewModelProvider.notifier).signOut();
          } on AuthException catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(error.message);
            }
          } catch (error) {
            if (context.mounted) {
              context
                  .showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
            }
          } finally {
            if (context.mounted) {
              Global.hideLoading();
              context.pushReplacement(Routes.register);
            }
          }
        },
      ),
    );
  }

  void _deleteAccount(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => CommonDialog(
        title: LocaleKeys.deleteAccountTitle.tr(),
        content: LocaleKeys.deleteAccountMessage.tr(),
        primaryButtonLabel: LocaleKeys.deleteAccount.tr(),
        primaryButtonBackground: AppColors.passionRed,
        secondaryButtonLabel: LocaleKeys.cancel.tr(),
        primaryButtonAction: () async {
          try {
            Global.showLoading(context);
            await ref.read(profileViewModelProvider.notifier).signOut();
          } on AuthException catch (error) {
            if (context.mounted) {
              context.showErrorSnackBar(error.message);
            }
          } catch (error) {
            if (context.mounted) {
              context
                  .showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
            }
          } finally {
            if (context.mounted) {
              Global.hideLoading();
              context.pushReplacement(Routes.register);
            }
          }
        },
      ),
    );
  }
}
