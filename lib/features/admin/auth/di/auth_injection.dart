import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/auth_gate.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/cubit/auth_cubit.dart';

/// Feature registrar for **admin auth**: the shared [SupabaseClient],
/// the repository, the [AuthGate] router bridge and the [AuthCubit].
void initAuthInjection() {
  getIt
    ..registerLazySingleton<AuthGate>(AuthGate.new)
    ..registerLazySingleton<AuthRepository>(
      () => SupabaseAuthRepository(getIt<SupabaseClient>()),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt<AuthRepository>(), getIt<AuthGate>()),
      dispose: (cubit) => cubit.close(),
    );
}
