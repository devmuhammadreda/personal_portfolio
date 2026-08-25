import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../../core/errors/app_failure.dart';
import '../../../../../core/mixin/cubit_lifecycle_mixin.dart';
import '../../../../portfolio/domain/entities/contact_message.dart';
import '../../../../portfolio/domain/repositories/contact_message_repository.dart';
import 'messages_admin_state.dart';

final class MessagesAdminCubit extends Cubit<MessagesAdminState>
    with CubitLifecycleMixin<MessagesAdminState> {
  MessagesAdminCubit(this._messageRepository)
    : super(const MessagesAdminState());

  final ContactMessageRepository _messageRepository;

  Future<void> load() async {
    emit(state.copyWith(status: MessagesAdminStatus.loading, clearError: true));
    try {
      final messages = await _messageRepository.getMessages();
      safeEmit(
        state.copyWith(status: MessagesAdminStatus.ready, messages: messages),
      );
    } on AppFailure catch (failure) {
      safeEmit(
        state.copyWith(
          status: MessagesAdminStatus.failure,
          errorMessage: failure.message,
        ),
      );
    }
  }

  /// Marks the message read (optimistic) and returns it for display.
  Future<ContactMessage?> open(ContactMessage message) async {
    if (message.isUnread) {
      _patchLocal(message.id, (m) => m.copyWith(isRead: true));
      try {
        await _messageRepository.markAsRead(message.id);
      } on AppFailure catch (failure) {
        _patchLocal(message.id, (m) => m.copyWith(isRead: false));
        safeEmit(state.copyWith(errorMessage: failure.message));
      }
    }
    return state.messages.where((m) => m.id == message.id).firstOrNull;
  }

  Future<void> markAllAsRead() async {
    final unread = state.messages.where((m) => m.isUnread).toList();
    if (unread.isEmpty) return;
    safeEmit(
      state.copyWith(
        messages: [for (final m in state.messages) m.copyWith(isRead: true)],
      ),
    );
    try {
      for (final message in unread) {
        await _messageRepository.markAsRead(message.id);
      }
    } on AppFailure catch (failure) {
      safeEmit(state.copyWith(errorMessage: failure.message));
      await load();
    }
  }

  Future<void> delete(String messageId) async {
    _markBusy(messageId, true);
    try {
      await _messageRepository.deleteMessage(messageId);
      safeEmit(
        state.copyWith(
          messages: state.messages.where((m) => m.id != messageId).toList(),
        ),
      );
    } on AppFailure catch (failure) {
      safeEmit(state.copyWith(errorMessage: failure.message));
    } finally {
      _markBusy(messageId, false);
    }
  }

  void dismissError() => emit(state.copyWith(clearError: true));

  void _patchLocal(String id, ContactMessage Function(ContactMessage) patch) {
    safeEmit(
      state.copyWith(
        messages: [for (final m in state.messages) m.id == id ? patch(m) : m],
      ),
    );
  }

  void _markBusy(String id, bool busy) {
    final busyIds = {...state.busyIds};
    busy ? busyIds.add(id) : busyIds.remove(id);
    emit(state.copyWith(busyIds: busyIds));
  }
}
