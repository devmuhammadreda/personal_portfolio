import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/di/injector.dart';
import '../../../core/router/portfolio_router.dart';
import '../data/datasources/contact_message_remote_data_source.dart';
import '../data/datasources/profile_remote_data_source.dart';
import '../data/datasources/project_remote_data_source.dart';
import '../data/datasources/supabase_contact_message_data_source.dart';
import '../data/datasources/supabase_profile_data_source.dart';
import '../data/datasources/supabase_project_data_source.dart';
import '../data/datasources/supabase_timeline_data_source.dart';
import '../data/datasources/timeline_remote_data_source.dart';
import '../data/repositories/contact_message_repository_impl.dart';
import '../data/repositories/profile_repository_impl.dart';
import '../data/repositories/project_repository_impl.dart';
import '../data/repositories/timeline_repository_impl.dart';
import '../domain/repositories/contact_message_repository.dart';
import '../domain/repositories/profile_repository.dart';
import '../domain/repositories/project_repository.dart';
import '../domain/repositories/timeline_repository.dart';

/// Content data registrations needed by **both** flavors: the admin
/// console edits the same profile/projects the public site displays.
void initPortfolioDataInjection() {
  getIt
    ..registerLazySingleton<ProfileRemoteDataSource>(
      () => SupabaseProfileDataSource(getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<ProjectRemoteDataSource>(
      () => SupabaseProjectDataSource(getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<ContactMessageRemoteDataSource>(
      () => SupabaseContactMessageDataSource(getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<TimelineRemoteDataSource>(
      () => SupabaseTimelineDataSource(getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<ProfileRepository>(
      () => ProfileRepositoryImpl(getIt<ProfileRemoteDataSource>()),
    )
    ..registerLazySingleton<ProjectRepository>(
      () => ProjectRepositoryImpl(getIt<ProjectRemoteDataSource>()),
    )
    ..registerLazySingleton<TimelineRepository>(
      () => TimelineRepositoryImpl(getIt<TimelineRemoteDataSource>()),
    )
    ..registerLazySingleton<ContactMessageRepository>(
      () =>
          ContactMessageRepositoryImpl(getIt<ContactMessageRemoteDataSource>()),
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
