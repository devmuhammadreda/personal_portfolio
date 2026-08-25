/// Base type surfaced by repositories; Cubits map it to UI error states.
sealed class AppFailure {
  const AppFailure(this.message);

  final String message;

  @override
  String toString() => message;
}

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);

  /// Maps Supabase GoTrue error messages to friendly copy.
  factory AuthFailure.fromMessage(String message) {
    final String friendly = switch (message.toLowerCase()) {
      final m when m.contains('invalid login credentials') =>
        'Invalid email or password.',
      final m when m.contains('email not confirmed') =>
        'Please confirm your email address first.',
      final m when m.contains('disabled') => 'This account has been disabled.',
      final m when m.contains('rate limit') || m.contains('too many') =>
        'Too many attempts. Please wait and try again later.',
      final m when m.contains('network') =>
        'Network error. Check your connection.',
      _ => 'Sign-in failed. Please try again.',
    };
    return AuthFailure(friendly);
  }
}

final class FirestoreFailure extends AppFailure {
  const FirestoreFailure(super.message);

  /// Maps Supabase PostgREST error messages/codes to friendly copy.
  factory FirestoreFailure.fromCode(String codeOrMessage) {
    final String lowered = codeOrMessage.toLowerCase();
    final String message = switch (lowered) {
      final m
          when m.contains('42501') ||
              m.contains('permission') ||
              m.contains('row-level security') =>
        'You do not have permission to perform this action.',
      final m when m.contains('jwt') || m.contains('session') =>
        'Your session has expired. Please sign in again.',
      final m
          when m.contains('fetch') ||
              m.contains('socket') ||
              m.contains('network') =>
        'Network error. Check your connection.',
      _ => 'Something went wrong while syncing data.',
    };
    return FirestoreFailure(message);
  }
}

final class StorageFailure extends AppFailure {
  const StorageFailure(super.message);

  /// Maps Supabase Storage error messages to friendly copy.
  factory StorageFailure.fromMessage(String message) {
    final String lowered = message.toLowerCase();
    final String friendly = switch (lowered) {
      final m when m.contains('not found') =>
        'The file no longer exists on the server.',
      final m
          when m.contains('unauthorized') ||
              m.contains('row-level security') ||
              m.contains('permission') =>
        'You are not allowed to upload this file.',
      final m when m.contains('payload too large') || m.contains('exceeds') =>
        'That file is too large to upload.',
      _ => 'File upload failed. Please try again.',
    };
    return StorageFailure(friendly);
  }
}
