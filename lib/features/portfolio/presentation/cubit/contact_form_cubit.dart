import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/app_failure.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/repositories/contact_message_repository.dart';

enum ContactFormStatus { idle, sending, success, failure }

final class ContactFormState extends Equatable {
  const ContactFormState({
    this.status = ContactFormStatus.idle,
    this.errorMessage,
  });

  final ContactFormStatus status;
  final String? errorMessage;

  @override
  List<Object?> get props => [status, errorMessage];

  ContactFormState copyWith({
    ContactFormStatus? status,
    String? errorMessage,
    bool clearError = false,
  }) {
    return ContactFormState(
      status: status ?? this.status,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

final class ContactFormCubit extends Cubit<ContactFormState> {
  ContactFormCubit(this._repository) : super(const ContactFormState());

  final ContactMessageRepository _repository;

  /// Persists the message; a database webhook then emails it to the owner.
  Future<void> submit({
    required String name,
    required String email,
    required String message,
    String? phone,
  }) async {
    emit(state.copyWith(status: ContactFormStatus.sending, clearError: true));
    try {
      await _repository.sendMessage(
        ContactMessage(
          id: '',
          name: name.trim(),
          email: email.trim(),
          message: message.trim(),
          phone: (phone == null || phone.trim().isEmpty) ? null : phone.trim(),
          createdAt: DateTime.now(),
          isRead: false,
        ),
      );
      emit(state.copyWith(status: ContactFormStatus.success));
    } on AppFailure catch (failure) {
      emit(
        state.copyWith(
          status: ContactFormStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  /// Returns to idle after success/failure was consumed by the UI.
  void reset() => emit(const ContactFormState());
}
