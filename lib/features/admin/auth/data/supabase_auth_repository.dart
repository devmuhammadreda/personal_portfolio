import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/authentication_status.dart';
import '../domain/entities/admin_user.dart';
import '../domain/repositories/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  SupabaseAuthRepository(this._client);

  final SupabaseClient _client;

  @override
  AdminUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AdminUser(uid: user.id, email: user.email ?? '');
  }

  @override
  Stream<AuthenticationStatus> statusStream() {
    return _client.auth.onAuthStateChange.map((event) {
      return event.session == null
          ? AuthenticationStatus.unauthenticated
          : AuthenticationStatus.authenticated;
    });
  }

  @override
  Future<void> signIn({required String email, required String password}) async {
    try {
      await _client.auth.signInWithPassword(email: email, password: password);
    } on AuthException catch (error) {
      throw AuthFailure.fromMessage(error.message);
    } catch (_) {
      throw const AuthFailure('Sign-in failed. Please try again.');
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } on AuthException catch (error) {
      throw AuthFailure.fromMessage(error.message);
    }
  }
}
