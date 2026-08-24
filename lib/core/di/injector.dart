import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../../features/admin/auth/data/firebase_auth_repository.dart';
import '../../features/admin/auth/presentation/cubit/auth_cubit.dart';
import '../../features/admin/auth/domain/repositories/auth_repository.dart';
import '../../features/admin/media/data/firebase_media_storage_repository.dart';
import '../../features/admin/media/domain/repositories/media_storage_repository.dart';
import '../../features/portfolio/data/datasources/firestore_profile_data_source.dart';
import '../../features/portfolio/data/datasources/firestore_project_data_source.dart';
import '../../features/portfolio/data/datasources/profile_remote_data_source.dart';
import '../../features/portfolio/data/datasources/project_remote_data_source.dart';
import '../../features/portfolio/data/repositories/profile_repository_impl.dart';
import '../../features/portfolio/data/repositories/project_repository_impl.dart';
import '../../features/portfolio/domain/repositories/profile_repository.dart';
import '../../features/portfolio/domain/repositories/project_repository.dart';
import '../router/app_router.dart';
import '../router/auth_gate.dart';
import '../theme/theme_cubit.dart';

final GetIt getIt = GetIt.instance;

void configureDependencies() {
  getIt
    // Core presentation
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    ..registerLazySingleton<AuthGate>(AuthGate.new)
    // Firebase SDKs (lazy — only resolved once configured)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    )
    ..registerLazySingleton<FirebaseStorage>(() => FirebaseStorage.instance)
    // Portfolio data
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => FirestoreProfileDataSource(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<ProjectRemoteDataSource>(
      () => FirestoreProjectDataSource(getIt<FirebaseFirestore>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
    )
    ..registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(getIt<ProjectRemoteDataSource>()),
    )
    // Admin
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt<FirebaseAuth>()),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt<AuthRepository>(), getIt<AuthGate>()),
      dispose: (cubit) => cubit.close(),
    )
    ..registerLazySingleton<MediaStorageRepository>(
      () => FirebaseMediaStorageRepository(getIt<FirebaseStorage>()),
    )
    // Routing (last — depends on AuthGate)
    ..registerLazySingleton<GoRouter>(
      () => createAppRouter(getIt<AuthGate>()),
      dispose: (GoRouter router) => router.dispose(),
    );
}
