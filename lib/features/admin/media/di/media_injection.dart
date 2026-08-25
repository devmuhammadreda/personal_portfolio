import 'package:firebase_storage/firebase_storage.dart';

import '../../../../core/di/injector.dart';
import '../data/firebase_media_storage_repository.dart';
import '../domain/repositories/media_storage_repository.dart';

/// Feature registrar for **admin media**: Firebase Storage SDK and the
/// upload/delete repository used by the profile and project editors.
void initMediaInjection() {
  getIt
    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance)
    ..registerLazySingleton<MediaStorageRepository>(
      () => FirebaseMediaStorageRepository(getIt<FirebaseStorage>()),
    );
}
