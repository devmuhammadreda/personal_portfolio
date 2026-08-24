import 'dart:typed_data';

import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/errors/app_failure.dart';
import '../domain/repositories/media_storage_repository.dart';

class FirebaseMediaStorageRepository implements MediaStorageRepository {
  FirebaseMediaStorageRepository(this._storage);

  final FirebaseStorage _storage;

  @override
  Future<String> uploadBytes({
    required String storagePath,
    required Uint8List bytes,
    required String contentType,
  }) async {
    try {
      final ref = _storage.ref(storagePath);
      final metadata = SettableMetadata(contentType: contentType);
      await ref.putData(bytes, metadata);
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (error) {
      throw StorageFailure.fromCode(error.code);
    }
  }

  @override
  Future<void> deleteByUrl(String url) async {
    try {
      final String? objectPath = _extractObjectPath(url);
      if (objectPath == null) {
        throw const StorageFailure('Unrecognised storage URL.');
      }
      await _storage.ref(objectPath).delete();
    } on FirebaseException catch (error) {
      if (error.code == 'object-not-found') return;
      throw StorageFailure.fromCode(error.code);
    }
  }

  /// Extracts the decoded object path from a download URL of the form
  /// `https://firebasestorage.googleapis.com/v0/b/<bucket>/o/<encoded-path>?…`
  String? _extractObjectPath(String url) {
    final uri = Uri.tryParse(url);
    if (uri == null) return null;
    final segments = uri.pathSegments;
    final index = segments.indexOf('o');
    if (index < 0 || index + 1 >= segments.length) return null;
    return Uri.decodeComponent(segments[index + 1]);
  }
}
