import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/flavor/flavor_settings.dart';
import 'profile_remote_data_source.dart';

/// Single-row profile table (`profile`, id = 1).
class SupabaseProfileDataSource implements ProfileRemoteDataSource {
  SupabaseProfileDataSource(this._client);

  final SupabaseClient _client;

  SupabaseQueryBuilder get _table => _client.from(FlavorSettings.profileTable);

  @override
  Future<Map<String, dynamic>?> fetchProfileMap() async {
    final row = await _table.select().eq('id', _rowId).maybeSingle();
    return row;
  }

  @override
  Stream<Map<String, dynamic>?> watchProfileMap() {
    return _table
        .stream(primaryKey: ['id'])
        .map((rows) => rows.isEmpty ? null : rows.first);
  }

  @override
  Future<void> upsertProfileMap(Map<String, dynamic> map) async {
    await _table.upsert({...map, 'id': _rowId});
  }

  static const int _rowId = 1;
}
