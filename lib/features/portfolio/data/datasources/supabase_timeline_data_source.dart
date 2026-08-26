import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/flavor/flavor_settings.dart';
import 'timeline_remote_data_source.dart';

/// Read/write `work_experience` / `education` tables — the public site
/// renders them as timeline sections, the admin console edits them.
class SupabaseTimelineDataSource implements TimelineRemoteDataSource {
  SupabaseTimelineDataSource(this._client);

  final SupabaseClient _client;

  SupabaseQueryBuilder get _experienceTable =>
      _client.from(FlavorSettings.workExperienceTable);

  SupabaseQueryBuilder get _educationTable =>
      _client.from(FlavorSettings.educationTable);

  @override
  Future<List<Map<String, dynamic>>> fetchWorkExperienceMaps() =>
      _experienceTable.select().order('order');

  @override
  Future<List<Map<String, dynamic>>> fetchEducationMaps() =>
      _educationTable.select().order('order');

  @override
  Future<String> saveWorkExperienceMap(
    Map<String, dynamic> map, {
    String? id,
  }) => _save(_experienceTable, map, id: id);

  @override
  Future<void> deleteWorkExperience(String id) =>
      _experienceTable.delete().eq('id', id);

  /// Sequential updates are fine at portfolio scale (< 100 rows); each
  /// write is guarded by the admin RLS policy.
  @override
  Future<void> reorderWorkExperience(List<String> idsInOrder) =>
      _reorder(_experienceTable, idsInOrder);

  @override
  Future<String> saveEducationMap(Map<String, dynamic> map, {String? id}) =>
      _save(_educationTable, map, id: id);

  @override
  Future<void> deleteEducation(String id) =>
      _educationTable.delete().eq('id', id);

  @override
  Future<void> reorderEducation(List<String> idsInOrder) =>
      _reorder(_educationTable, idsInOrder);

  Future<String> _save(
    SupabaseQueryBuilder table,
    Map<String, dynamic> map, {
    String? id,
  }) async {
    if (id == null || id.isEmpty) {
      final row = await table.insert(map).select('id').single();
      return row['id'] as String;
    }
    await table.update(map).eq('id', id);
    return id;
  }

  Future<void> _reorder(SupabaseQueryBuilder table, List<String> ids) async {
    for (var i = 0; i < ids.length; i++) {
      await table.update({'order': i}).eq('id', ids[i]);
    }
  }
}
