import 'package:equatable/equatable.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../domain/entities/admin_user.dart';

sealed class AuthState extends Equatable {
  const AuthState();

  @override
  List<Object?> get props => [];
}

final class AuthUnknown extends AuthState {
  const AuthUnknown();
}

final class Authenticated extends AuthState {
  const Authenticated(this.user);

  final AdminUser user;

  @override
  List<Object?> get props => [user];
}

final class Unauthenticated extends AuthState {
  const Unauthenticated({this.submitting = false, this.errorMessage});

  /// True while a sign-in request is in flight.
  final bool submitting;
  final String? errorMessage;

  @override
  List<Object?> get props => [submitting, errorMessage];

  Unauthenticated copyWith({bool? submitting, String? errorMessage, bool clearError = false}) {
    return Unauthenticated(
      submitting: submitting ?? this.submitting,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  static Unauthenticated fromFailure(AppFailure failure) =>
      Unauthenticated(errorMessage: failure.message);
}
