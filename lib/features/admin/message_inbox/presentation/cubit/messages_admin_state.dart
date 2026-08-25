import 'package:equatable/equatable.dart';

import '../../../../portfolio/domain/entities/contact_message.dart';

enum MessagesAdminStatus { loading, ready, failure }

final class MessagesAdminState extends Equatable {
  const MessagesAdminState({
    this.status = MessagesAdminStatus.loading,
    this.messages = const [],
    this.busyIds = const {},
    this.errorMessage,
  });

  final MessagesAdminStatus status;
  final List<ContactMessage> messages;

  /// Ids with an in-flight mutation (mark-read / delete).
  final Set<String> busyIds;
  final String? errorMessage;

  int get unreadCount => messages.where((m) => m.isUnread).length;

  MessagesAdminState copyWith({
    MessagesAdminStatus? status,
    List<ContactMessage>? messages,
    Set<String>? busyIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return MessagesAdminState(
      status: status ?? this.status,
      messages: messages ?? this.messages,
      busyIds: busyIds ?? this.busyIds,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }

  @override
  List<Object?> get props => [status, messages, busyIds, errorMessage];
}
