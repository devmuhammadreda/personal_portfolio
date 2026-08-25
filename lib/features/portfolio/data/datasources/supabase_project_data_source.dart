import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/flavor/flavor_settings.dart';
import 'project_remote_data_source.dart';

/// `projects` table — uuid PK, ordered by the integer `order` column.
class SupabaseProjectDataSource implements ProjectRemoteDataSource {
  SupabaseProjectDataSource(this._client);

  final SupabaseClient _client;

  SupabaseQueryBuilder get _table => _client.from(FlavorSettings.projectsTable);

  @override
  Future<List<ProjectDoc>> fetchProjectMaps() async {
    final rows = await _table.select().order('order', ascending: true);
    return rows.map(_toDoc).toList();
  }

  @override
  Stream<List<ProjectDoc>> watchProjectMaps() {
    // Realtime streams arrive unordered — sort by the order column here
    return _table
        .stream(primaryKey: ['id'])
        .map((rows) => (rows..sort(_byOrder)).map(_toDoc).toList());
  }

  @override
  Future<String> saveProjectMap(Map<String, dynamic> map, {String? id}) async {
    if (id == null || id.isEmpty) {
      final row = await _table.insert(map).select('id').single();
      return row['id'] as String;
    }
    await _table.update(map).eq('id', id);
    return id;
  }

  @override
  Future<void> deleteProject(String id) async {
    await _table.delete().eq('id', id);
  }

  /// Sequential updates are fine at portfolio scale (< 100 rows); each
  /// write is guarded by the admin RLS policy.
  @override
  Future<void> applyOrder(List<String> projectIdsInOrder) async {
    for (var i = 0; i < projectIdsInOrder.length; i++) {
      await _table.update({'order': i}).eq('id', projectIdsInOrder[i]);
    }
  }

  ProjectDoc _toDoc(Map<String, dynamic> row) =>
      (id: row['id'] as String, map: row);

  int _byOrder(Map<String, dynamic> a, Map<String, dynamic> b) =>
      ((a['order'] as num? ?? 0) - (b['order'] as num? ?? 0)).sign.toInt();
}
