import '../entities/profile.dart';

abstract interface class ProfileRepository {
  /// Single-shot fetch of the portfolio profile (`profile/main`).
  Future<Profile> getProfile();

  /// Reactive stream of the profile for live UI updates.
  Stream<Profile> watchProfile();

  /// Creates or overwrites the profile document.
  Future<void> saveProfile(Profile profile);
}
