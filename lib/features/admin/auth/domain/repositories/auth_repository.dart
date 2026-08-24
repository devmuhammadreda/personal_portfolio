import '../../../../../core/router/authentication_status.dart';
import '../entities/admin_user.dart';

abstract interface class AuthRepository {
  AdminUser? get currentUser;

  /// Emits the current status and every subsequent change (sign-in,
  /// sign-out, session expiry) — the single source of truth for the
  /// router guard.
  Stream<AuthenticationStatus> statusStream();

  Future<void> signIn({required String email, required String password});

  Future<void> signOut();
}
