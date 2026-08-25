import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injector.dart';
import '../data/supabase_media_storage_repository.dart';
import '../domain/repositories/media_storage_repository.dart';

/// Feature registrar for **admin media**: the upload/delete repository
/// used by the profile and project editors, backed by Supabase Storage.
void initMediaInjection() {
  getIt.registerLazySingleton<MediaStorageRepository>(
    () => SupabaseMediaStorageRepository(getIt<SupabaseClient>()),
  );
}
