import 'package:get_it/get_it.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../localizations_cubit/locale_cubit.dart';
import '../theme/theme_cubit.dart';

/// Shared service locator. Flavor modules
/// (`portfolio_dependencies.dart`, `admin_dependencies.dart`) and their
/// per-feature registrars extend it with their own registrations.
final GetIt getIt = GetIt.instance;

/// Platform-level registrations shared by every flavor: theme, locale
/// and the Supabase client instance.
void configureCoreDependencies() {
  getIt
    // Core presentation
    ..registerLazySingleton<ThemeCubit>(ThemeCubit.new)
    ..registerLazySingleton<LocaleCubit>(LocaleCubit.new)
    // Supabase SDK (lazy — only resolved once configured)
    ..registerLazySingleton<SupabaseClient>(() => Supabase.instance.client);
}
