/// Base type surfaced by repositories; Cubits map it to UI error states.
sealed class AppFailure {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);

  factory AuthFailure.fromCode(String code) {
    final String message = switch (code) {
      'invalid-email' => 'That email address looks malformed.',
      'user-disabled' => 'This account has been disabled.',
      'user-not-found' ||
      'wrong-password' ||
      'invalid-credential' => 'Invalid email or password.',
      'too-many-requests' =>
        'Too many attempts. Please wait and try again later.',
      'network-request-failed' => 'Network error. Check your connection.',
      _ => 'Sign-in failed. Please try again.',
    };
    return AuthFailure(message);
  }
}

final class FirestoreFailure extends AppFailure {
  const FirestoreFailure(super.message);

  factory FirestoreFailure.fromCode(String code) {
    final String message = switch (code) {
      'permission-denied' =>
        'You do not have permission to perform this action.',
      'not-found' => 'The requested document was not found.',
      'unavailable' =>
        'Service is currently unavailable. Please try again shortly.',
      'unauthenticated' => 'Your session has expired. Please sign in again.',
      _ => 'Something went wrong while syncing data.',
    };
    return FirestoreFailure(message);
  }
}

final class StorageFailure extends AppFailure {
  const StorageFailure(super.message);

  factory StorageFailure.fromCode(String code) {
    final String message = switch (code) {
      'object-not-found' => 'The file no longer exists on the server.',
      'unauthorized' => 'You are not allowed to upload this file.',
      'canceled' => 'Upload cancelled.',
      'retry-limit-exceeded' =>
        'Upload took too long. Please check your connection and retry.',
      _ => 'File upload failed. Please try again.',
    };
    return StorageFailure(message);
  }
}
