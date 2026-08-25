import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_it/get_it.dart';

import '../theme/theme_cubit.dart';

/// Shared service locator. Flavor modules
/// (`portfolio_dependencies.dart`, `admin_dependencies.dart`) and their
/// per-feature registrars extend it with their own registrations.
final GetIt getIt = GetIt.instance;

/// Platform-level registrations shared by every flavor: theme + the
/// Firestore SDK instance. Feature-owned data sources, repositories,
/// auth and routers live in each feature's own registrar
/// (`di/*_injection.dart` / `di/*_dependencies.dart`).
void configureCoreDependencies() {
  getIt
    // Core presentation
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    // Firebase SDK (lazy — only resolved once configured)
    ..registerLazySingleton<FirebaseFirestore>(
      () => FirebaseFirestore.instance,
    );
}
