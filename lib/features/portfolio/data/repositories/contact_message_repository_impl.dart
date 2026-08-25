import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/errors/app_failure.dart';
import '../datasources/contact_message_remote_data_source.dart';
import '../models/contact_message_model.dart';
import '../../domain/entities/contact_message.dart';
import '../../domain/repositories/contact_message_repository.dart';

class ContactMessageRepositoryImpl implements ContactMessageRepository {
  ContactMessageRepositoryImpl(this._dataSource);

  final ContactMessageRemoteDataSource _dataSource;

  @override
  Future<void> sendMessage(ContactMessage message) async {
    try {
      await _dataSource.insertMessage(
        ContactMessageModel.fromEntity(message).toInsertMap(),
      );
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<List<ContactMessage>> getMessages() async {
    try {
      final docs = await _dataSource.fetchMessageMaps();
      return docs.map(_toEntity).toList();
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> markAsRead(String messageId) async {
    try {
      await _dataSource.markAsRead(messageId);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  @override
  Future<void> deleteMessage(String messageId) async {
    try {
      await _dataSource.deleteMessage(messageId);
    } on PostgrestException catch (error) {
      throw FirestoreFailure.fromCode(error.message);
    }
  }

  ContactMessage _toEntity(ContactMessageDoc doc) {
    return ContactMessageModel.fromMap(doc.id, doc.map);
  }
}
