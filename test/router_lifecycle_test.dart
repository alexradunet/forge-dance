import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/constants/constants.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/ui/view_model/profile_view_model.dart';
import 'package:forge_dance/routing/router.dart';
import 'package:forge_dance/routing/routes.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('refreshing restored profile preserves the open backup route', () async {
    SharedPreferences.setMockInitialValues({
      Constants.profileKey: jsonEncode(
        const Profile(name: 'Before restore').toJson(),
      ),
    });
    final container = ProviderContainer();
    addTearDown(container.dispose);
    await container.read(profileViewModelProvider.future);
    container.read(routerProvider).go(Routes.dataTransfer);
    await pumpEventQueue();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      Constants.profileKey,
      jsonEncode(const Profile(name: 'Restored dancer').toJson()),
    );
    await container.read(profileViewModelProvider.notifier).refreshProfile();
    await pumpEventQueue();

    expect(
      container.read(routerProvider).routeInformationProvider.value.uri.path,
      Routes.dataTransfer,
    );
    expect(
      container.read(profileViewModelProvider).value?.profile?.name,
      'Restored dancer',
    );
  });
}
