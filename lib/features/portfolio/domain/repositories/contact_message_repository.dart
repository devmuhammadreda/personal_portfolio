import '../entities/contact_message.dart';

abstract interface class ContactMessageRepository {
  /// Persists a visitor's message; the database webhook then emails a
  /// notification to the owner.
  Future<void> sendMessage(ContactMessage message);

  /// Every message, newest first.
  Future<List<ContactMessage>> getMessages();

  Future<void> markAsRead(String messageId);

  Future<void> deleteMessage(String messageId);
}
