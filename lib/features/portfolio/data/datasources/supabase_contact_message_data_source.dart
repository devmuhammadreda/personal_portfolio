import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/flavor/flavor_settings.dart';
import 'contact_message_remote_data_source.dart';

/// `contact_messages` table — uuid PK, newest first via `created_at`.
class SupabaseContactMessageDataSource
    implements ContactMessageRemoteDataSource {
  SupabaseContactMessageDataSource(this._client);

  final SupabaseClient _client;

  SupabaseQueryBuilder get _table =>
      _client.from(FlavorSettings.contactMessagesTable);

  @override
  Future<void> insertMessage(Map<String, dynamic> map) async {
    await _table.insert(map);
  }

  @override
  Future<List<ContactMessageDoc>> fetchMessageMaps() async {
    final rows = await _table.select().order('createdAt', ascending: false);
    return rows.map(_toDoc).toList();
  }

  @override
  Future<void> markAsRead(String id) async {
    await _table.update({'isRead': true}).eq('id', id);
  }

  @override
  Future<void> deleteMessage(String id) async {
    await _table.delete().eq('id', id);
  }

  ContactMessageDoc _toDoc(Map<String, dynamic> row) =>
      (id: row['id'] as String, map: row);
}
