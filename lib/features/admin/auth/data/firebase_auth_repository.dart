import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/errors/app_failure.dart';
import '../../../../core/router/authentication_status.dart';
import '../domain/entities/admin_user.dart';
import '../domain/repositories/auth_repository.dart';

class FirebaseAuthRepository implements AuthRepository {
  FirebaseAuthRepository(this._firebaseAuth);

  final FirebaseAuth _firebaseAuth;

  @override
  AdminUser? get currentUser {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;
    return AdminUser(uid: user.uid, email: user.email ?? '');
  }

  @override
  Stream<AuthenticationStatus> statusStream() {
    return _firebaseAuth.authStateChanges().map((user) {
      return user == null
          ? AuthenticationStatus.unauthenticated
          : AuthenticationStatus.authenticated;
    });
  }

  @override
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
    } on FirebaseAuthException catch (error) {
      throw AuthFailure.fromCode(error.code);
    }
  }
}
