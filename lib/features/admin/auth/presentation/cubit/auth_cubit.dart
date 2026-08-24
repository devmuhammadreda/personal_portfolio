import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/router/auth_gate.dart';
import '../../../../../core/router/authentication_status.dart';
import '../../domain/entities/admin_user.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';

/// Bridges [FirebaseAuth]-backed auth status into the app: emits UI state
/// here and pushes every change into the [AuthGate] that drives the
/// router guard — including automatic logout on session expiry.
final class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._authRepository, this._authGate) : super(const AuthUnknown()) {
    _initialise();
  }

  final AuthRepository _authRepository;
  final AuthGate _authGate;
  StreamSubscription<AuthenticationStatus>? _subscription;

  void _initialise() {
    // Fast path for an existing session (avoids a login flash on reload).
    final AdminUser? current = _authRepository.currentUser;
    if (current != null) {
      _apply(AuthenticationStatus.authenticated);
    }
    _subscription ??= _authRepository.statusStream().listen(_apply);
  }

  void _apply(AuthenticationStatus status) {
    _authGate.update(status);
    switch (status) {
      case AuthenticationStatus.authenticated:
        final user = _authRepository.currentUser;
        if (user != null) emit(Authenticated(user));
      case AuthenticationStatus.unauthenticated ||
          AuthenticationStatus.unknown:
        if (state is! Unauthenticated) emit(const Unauthenticated());
    }
  }

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    final current = state;
    if (current is Authenticated) return;
    emit(const Unauthenticated(submitting: true));
    try {
      await _authRepository.signIn(email: email, password: password);
      // The status stream flips state + gate on success.
    } on AppFailure catch (failure) {
      emit(Unauthenticated.fromFailure(failure));
    } catch (_) {
      emit(
        const Unauthenticated(
          errorMessage: 'Sign-in failed. Please try again.',
        ),
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _authRepository.signOut();
    } on AppFailure catch (failure) {
      // Session already gone locally; surface only real errors.
      if (state is Authenticated) {
        emit(Unauthenticated(errorMessage: failure.message));
      }
    }
  }

  @override
  Future<void> close() {
    _subscription?.cancel();
    return super.close();
  }
}
