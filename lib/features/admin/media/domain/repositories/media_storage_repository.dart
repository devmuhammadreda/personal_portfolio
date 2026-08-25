import 'dart:typed_data';

abstract interface class MediaStorageRepository {
  /// Uploads [bytes] to [storagePath] (e.g. `projects/images/my-shot.png`)
  /// and resolves with the public download URL.
  Future<String> uploadBytes({
    required String storagePath,
    required Uint8List bytes,
    required String contentType,
  });

  /// Deletes the object behind a storage download [url].
  Future<void> deleteByUrl(String url);
}
