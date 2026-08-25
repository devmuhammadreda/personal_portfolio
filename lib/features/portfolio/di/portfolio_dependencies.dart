import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:go_router/go_router.dart';

import '../../../core/di/injector.dart';
import '../../../core/router/portfolio_router.dart';
import '../data/datasources/firestore_profile_data_source.dart';
import '../data/datasources/firestore_project_data_source.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/datasources/project_remote_data_source.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/repositories/project_repository_impl.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/project_repository.dart';

/// Content data registrations needed by **both** flavors: the admin
/// console edits the same profile/projects the public site displays.
void initPortfolioDataInjection() {
  getIt
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
    );
}

/// Flavor module for the **portfolio** build: content data plus the
/// public-only router.
void configurePortfolioDependencies() {
  initPortfolioDataInjection();
  getIt.registerLazySingleton<GoRouter>(
    () => createPortfolioRouter(),
    dispose: (GoRouter router) => router.dispose(),
  );
}
