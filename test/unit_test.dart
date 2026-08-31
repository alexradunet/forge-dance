import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
import 'package:forge_dance/features/profile/repository/device_avatar_repository.dart';
import 'package:forge_dance/features/profile/ui/view_model/profile_view_model.dart';
import 'package:forge_dance/utils/validator.dart';

class FakeProfileRepository extends ProfileRepository {
  FakeProfileRepository(this.profile) : super(auth: null, firestore: null);

  Profile? profile;
  Profile? savedProfile;

  @override
  Future<Profile?> get() async => profile;

  @override
  Future<void> update(Profile profile) async {
    savedProfile = profile;
    this.profile = profile;
  }
}

class FakeAvatarPicker implements AvatarPicker {
  FakeAvatarPicker(this.path);
  final String? path;
  @override
  Future<String?> select() async => path;
}

class FakeAvatarStorage implements AvatarStorage {
  String? savedSource;
  @override
  Future<String?> load(String identity) async => null;
  @override
  Future<String> save(String identity, String sourcePath) async {
    savedSource = sourcePath;
    return '/saved/$identity.png';
  }
}

void main() {
  group('validators', () {
    test('validates email format', () {
      expect(isValidEmail('dancer@example.com'), isTrue);
      expect(isValidEmail('dancer.name+tag@example.co.uk'), isTrue);
      expect(isValidEmail('missing-at.example.com'), isFalse);
      expect(isValidEmail('missing-domain@'), isFalse);
    });

    test('validates local phone format', () {
      expect(isValidPhone('0123456789'), isTrue);
      expect(isValidPhone('1123456789'), isFalse);
      expect(isValidPhone('012345678'), isFalse);
      expect(isValidPhone('01234567890'), isFalse);
    });

    test('validates email or phone format', () {
      expect(isValidEmailOrPhone('dancer@example.com'), isTrue);
      expect(isValidEmailOrPhone('0123456789'), isTrue);
      expect(isValidEmailOrPhone('not a contact'), isFalse);
    });
  });

  group('ProfileViewModel', () {
    test('partial update preserves existing profile fields', () async {
      final repository = FakeProfileRepository(
        const Profile(
          id: 'user-1',
          email: 'old@example.com',
          name: 'Old Name',
          avatar: 'https://example.com/avatar.png',
          diamond: 42,
        ),
      );
      final container = ProviderContainer(
        overrides: [
          profileRepositoryProvider.overrideWithValue(repository),
        ],
      );
      addTearDown(container.dispose);

      await container.read(profileViewModelProvider.future);

      await container
          .read(profileViewModelProvider.notifier)
          .editProfile(name: 'New Name');

      const expectedProfile = Profile(
        id: 'user-1',
        email: 'old@example.com',
        name: 'New Name',
        avatar: 'https://example.com/avatar.png',
        diamond: 42,
      );
      expect(repository.savedProfile, expectedProfile);
      expect(
        container.read(profileViewModelProvider).value?.profile,
        expectedProfile,
      );
    });

    test('authentication sync cannot replace a dancer-edited name', () async {
      final repository = FakeProfileRepository(
        const Profile(name: 'Chosen Name'),
      );
      final container = ProviderContainer(
        overrides: [profileRepositoryProvider.overrideWithValue(repository)],
      );
      addTearDown(container.dispose);
      await container.read(profileViewModelProvider.future);

      await container
          .read(profileViewModelProvider.notifier)
          .syncAuthentication(
            id: 'user-1',
            email: 'dancer@example.com',
            name: 'Auth Name',
          );

      expect(repository.savedProfile?.id, 'user-1');
      expect(repository.savedProfile?.email, 'dancer@example.com');
      expect(repository.savedProfile?.name, 'Chosen Name');
    });
  });

  test('device avatar coordinates picker and storage adapters', () async {
    final storage = FakeAvatarStorage();
    final avatar = DeviceAvatarRepository(
      picker: FakeAvatarPicker('/picked/image.png'),
      storage: storage,
    );

    expect(await avatar.selectAndSave('user-1'), '/saved/user-1.png');
    expect(storage.savedSource, '/picked/image.png');
  });
}
