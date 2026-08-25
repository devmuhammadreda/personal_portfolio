import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'core/di/injector.dart';
import 'features/admin/auth/presentation/cubit/auth_cubit.dart';
import 'features/admin/di/admin_dependencies.dart';
import 'main.dart' as app;

/// Entry point for the **admin** flavor.
///
/// Config only — the shared bootstrap in `main.dart` owns every init
/// step. Boots the guarded admin console with the public site still
/// reachable for previewing live content; banner label is debug-only.
Future<void> main() {
  FlavorConfig(
    name: kDebugMode ? 'ADMIN' : '',
    color: Colors.red,
    location: BannerLocation.topEnd,
    variables: {'flavor': 'admin'},
  );
  return app.runPersonalPortfolioApp(
    title: 'Flutter Developer Portfolio — Admin Console',
    extraProviders: [
      // Bridges Supabase auth state into the router guard. Created
      // lazily — the shared bootstrap configures admin dependencies
      // after these arguments are built.
      BlocProvider<AuthCubit>(create: (_) => getIt<AuthCubit>()),
    ],
    configureFlavorDependencies: configureAdminDependencies,
  );
}
