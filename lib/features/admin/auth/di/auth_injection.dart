import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/di/injector.dart';
import '../../../../core/router/auth_gate.dart';
import '../data/firebase_auth_repository.dart';
import '../domain/repositories/auth_repository.dart';
import '../presentation/cubit/auth_cubit.dart';

/// Feature registrar for **admin auth**: Firebase Auth SDK, the
/// repository, the [AuthGate] router bridge and the [AuthCubit].
void initAuthInjection() {
  getIt
    ..registerLazySingleton<AuthGate>(AuthGate.new)
    ..registerLazySingleton<FirebaseAuth>(() => FirebaseAuth.instance)
    ..registerLazySingleton<AuthRepository>(
      () => FirebaseAuthRepository(getIt<FirebaseAuth>()),
    )
    ..registerLazySingleton<AuthCubit>(
      () => AuthCubit(getIt<AuthRepository>(), getIt<AuthGate>()),
      dispose: (cubit) => cubit.close(),
    );
}
