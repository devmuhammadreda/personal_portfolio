import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/config/supabase_config.dart';
import '../../../../core/errors/app_failure.dart';
import '../domain/repositories/media_storage_repository.dart';

/// Public `portfolio-media` bucket: anyone can read, only admins can
/// write (enforced by storage RLS policies).
class SupabaseMediaStorageRepository implements MediaStorageRepository {
  SupabaseMediaStorageRepository(this._client);

  final SupabaseClient _client;

  @override
  Future<String> uploadBytes({
    required String storagePath,
    required Uint8List bytes,
    required String contentType,
  }) async {
    try {
      await _client.storage
          .from(SupabaseConfig.mediaBucket)
          .uploadBinary(
            storagePath,
            bytes,
            fileOptions: const FileOptions(upsert: true),
          );
      return _client.storage
          .from(SupabaseConfig.mediaBucket)
          .getPublicUrl(storagePath);
    } on StorageException catch (error) {
      throw StorageFailure.fromMessage(error.message);
    } catch (_) {
      throw const StorageFailure('File upload failed. Please try again.');
    }
  }

  @override
  Future<void> deleteByUrl(String url) async {
    final String? objectPath = _extractObjectPath(url);
    if (objectPath == null) {
      throw const StorageFailure('Unrecognised storage URL.');
    }
    try {
      await _client.storage.from(SupabaseConfig.mediaBucket).remove([
        objectPath,
      ]);
    } on StorageException catch (error) {
      if (error.statusCode == '404' || error.message.contains('not found')) {
        return; // Already gone — nothing to do.
      }
      throw StorageFailure.fromMessage(error.message);
    }
  }

  /// Extracts the object path from a public URL of the form
  /// `<project>/storage/v1/object/public/<bucket>/<path>`
  String? _extractObjectPath(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    final marker = 'object';
    final objectIndex = segments.indexOf(marker);
    if (objectIndex < 0 || objectIndex + 2 >= segments.length) return null;
    // Skip the visibility segment (`public`/`authenticated`) + bucket.
    return Uri.decodeComponent(segments.sublist(objectIndex + 3).join('/'));
  }
}
