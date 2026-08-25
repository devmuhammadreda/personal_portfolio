import '../../domain/entities/contact_message.dart';

final class ContactMessageModel extends ContactMessage {
  const ContactMessageModel({
    required super.id,
    required super.name,
    required super.email,
    required super.message,
    required super.createdAt,
    required super.isRead,
    super.phone,
  });

  factory ContactMessageModel.fromMap(String id, Map<String, dynamic> map) {
    return ContactMessageModel(
      id: id,
      name: map['name'] as String? ?? '',
      email: map['email'] as String? ?? '',
      message: map['message'] as String? ?? '',
      phone: map['phone'] as String?,
      createdAt: _toDateTime(map['createdAt']),
      isRead: map['isRead'] as bool? ?? false,
    );
  }

  factory ContactMessageModel.fromEntity(ContactMessage entity) {
    return ContactMessageModel(
      id: entity.id,
      name: entity.name,
      email: entity.email,
      message: entity.message,
      phone: entity.phone,
      createdAt: entity.createdAt,
      isRead: entity.isRead,
    );
  }

  /// Only the visitor-writable columns; `id`/`createdAt` are database
  /// defaults and `isRead` starts as false.
  Map<String, dynamic> toInsertMap() {
    return <String, dynamic>{
      'name': name,
      'email': email,
      'message': message,
      if (phone != null && phone!.trim().isNotEmpty) 'phone': phone!.trim(),
    };
  }

  static DateTime _toDateTime(dynamic value) => switch (value) {
    final String iso when iso.isNotEmpty =>
      DateTime.tryParse(iso) ?? DateTime.fromMillisecondsSinceEpoch(0),
    final DateTime dateTime => dateTime,
    _ => DateTime.fromMillisecondsSinceEpoch(0),
  };
}
