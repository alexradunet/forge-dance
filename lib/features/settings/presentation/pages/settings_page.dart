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
import '../../../../generated/locale_keys.g.dart';
import '../../../../routing/routes.dart';

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

    return FgImmersiveScaffold(
      title: LocaleKeys.settings.tr(),
      onBack: () => context.pop(),
      bodyBuilder: (context) => FgReadingBody(
        child: ListView(
          padding: AppSpacing.allXXL,
          children: [
            FgSectionHeading(
              title: LocaleKeys.personalYourSpace.tr(),
              subtitle: LocaleKeys.personalSettingsIntro.tr(),
            ),
            const SizedBox(height: AppSpacing.xxxl),
            _buildSettingsMenu(context, profile),
            const SizedBox(height: AppSpacing.xxxl),
            Text(
              'Version $_version',
              style: Theme.of(context).textTheme.labelSmall,
            ),
            const SizedBox(height: AppSpacing.xxl),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsMenu(BuildContext context, Profile? profile) {
    return Column(
      children: [
        ProfileMenuSection(
          title: LocaleKeys.general.tr(),
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
              icon: Icons.save_alt_rounded,
              label: LocaleKeys.forgeTransferTitle.tr(),
              onTap: () => context.push(Routes.dataTransfer),
            ),
          ],
        ),
        const SizedBox(height: AppSpacing.xxl),
        ProfileMenuSection(
          title: LocaleKeys.forgeSupport.tr(),
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
      ],
    );
  }

  void _getPackageInfo() {
    PackageInfo.fromPlatform()
        .then((info) {
          if (!mounted) return;
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
}
