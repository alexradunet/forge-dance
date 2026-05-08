import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:forge_dance/features/profile/model/profile.dart';
import 'package:forge_dance/features/profile/repository/profile_repository.dart';
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
          .updateProfile(name: 'New Name');

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
  });
}
