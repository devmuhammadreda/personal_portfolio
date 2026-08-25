import 'package:equatable/equatable.dart';

/// A message submitted through the public contact form.
class ContactMessage extends Equatable {
  const ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.createdAt,
    required this.isRead,
    this.phone,
  });

  /// Supabase row id. Empty for a not-yet-persisted message.
  final String id;
  final String name;
  final String email;
  final String message;

  /// International format (e.g. `+201234567890`); null when not provided.
  final String? phone;
  final DateTime createdAt;
  final bool isRead;

  bool get isUnread => !isRead;

  ContactMessage copyWith({bool? isRead}) {
    return ContactMessage(
      id: id,
      name: name,
      email: email,
      message: message,
      createdAt: createdAt,
      isRead: isRead ?? this.isRead,
    );
  }

  @override
  List<Object?> get props => [
    id,
    name,
    email,
    phone,
    message,
    createdAt,
    isRead,
  ];
}
