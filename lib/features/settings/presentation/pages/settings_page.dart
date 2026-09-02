import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../../constants/constants.dart';
import '../../../../extensions/build_context_extension.dart';
import '../../../../design_system/design_system.dart';
import '../../../../features/profile/model/profile.dart';
import '../../../../features/profile/ui/view_model/profile_view_model.dart';
import '../../../../features/profile/ui/widgets/profile_menu.dart';
import '../../../../features/session/application/session_coordinator.dart';
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
    final profile =
        widget.profile ??
        ref.watch(profileViewModelProvider.select((it) => it.value?.profile));

    return Scaffold(
      body: FgBackground(
        child: Column(
          children: [
            AppHeader(
              title: LocaleKeys.settings.tr().toUpperCase(),
              onBack: () => context.pop(),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: AppSpacing.xxl),
                      _buildSettingsMenu(profile),
                      const SizedBox(height: AppSpacing.huge2),
                      Center(
                        child: Text(
                          'Version $_version',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: Theme.of(context)
                                    .forgeColors
                                    .onImmersiveMuted,
                              ),
                        ),
                      ),
                      const SizedBox(height: AppSpacing.huge2),
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
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
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
              onTap: () => context.tryLaunchUrl(Constants.rateUs),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        ProfileMenuSection(
          title: 'Account',
          items: [
            ProfileMenuItem(
              icon: Icons.logout,
              label: LocaleKeys.logOut.tr(),
              tone: ProfileMenuTone.destructive,
              showArrow: false,
              onTap: () => _signOut(context),
            ),
            ProfileMenuItem(
              icon: Icons.delete_outline,
              label: LocaleKeys.deleteAccount.tr(),
              tone: ProfileMenuTone.destructive,
              showArrow: false,
              onTap: () => _deleteAccount(context),
            ),
          ],
        ),
      ],
    );
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform()
        .then((info) {
          setState(() {
            _version = info.version;
          });
        })
        .catchError((error) {
          debugPrint(
            '${Constants.tag} [_SettingsPageState._getPackageInfo] Error: $error',
          );
        });
  }

  void _signOut(BuildContext context) {
    ForgeAlertDialog.show(
      context: context,
      title: LocaleKeys.logOutTitle.tr(),
      message: LocaleKeys.logOutMessage.tr(),
      primaryActionLabel: LocaleKeys.logOut.tr(),
      secondaryActionLabel: LocaleKeys.cancel.tr(),
      tone: ForgeAlertTone.destructive,
      isPrimaryDestructive: true,
      onPrimaryAction: () async {
        try {
          Global.showLoading(context);
          await ref.read(sessionCoordinatorProvider).signOut();
          if (context.mounted) {
            context.pushReplacement(Routes.login);
          }
        } catch (error) {
          if (context.mounted) {
            context.showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
          }
        } finally {
          Global.hideLoading();
        }
      },
    );
  }

  void _deleteAccount(BuildContext context) {
    ForgeAlertDialog.show(
      context: context,
      title: LocaleKeys.deleteAccountTitle.tr(),
      message: LocaleKeys.deleteAccountMessage.tr(),
      primaryActionLabel: LocaleKeys.deleteAccount.tr(),
      secondaryActionLabel: LocaleKeys.cancel.tr(),
      tone: ForgeAlertTone.destructive,
      isPrimaryDestructive: true,
      onPrimaryAction: () async {
        try {
          Global.showLoading(context);
          await ref.read(sessionCoordinatorProvider).signOut();
          if (context.mounted) {
            context.pushReplacement(Routes.register);
          }
        } catch (error) {
          if (context.mounted) {
            context.showErrorSnackBar(LocaleKeys.unexpectedErrorOccurred.tr());
          }
        } finally {
          Global.hideLoading();
        }
      },
    );
  }
}
