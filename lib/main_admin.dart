import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/supabase/supabase_bootstrapper.dart';
import 'core/services/bloc_observer.dart';
import 'features/admin/auth/presentation/cubit/auth_cubit.dart';
import 'features/admin/di/admin_dependencies.dart';

/// Entry point for the **admin** flavor.
///
/// Boots the guarded admin console (login → dashboard) with the public
/// site still reachable for previewing live content. The banner label is
/// shown in debug mode only; release builds hide it (empty name).
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlavorConfig(
    name: kDebugMode ? 'ADMIN' : '',
    color: Colors.red,
    location: BannerLocation.topEnd,
    variables: {'flavor': 'admin'},
  );
  configureCoreDependencies();
  configureAdminDependencies();
  await SupabaseBootstrapper.initialise();
  runApp(
    PersonalPortfolioApp(
      title: 'Flutter Developer Portfolio — Admin Console',
      extraProviders: [
        // Bridges Supabase auth state into the router guard.
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
      ],
    ),
  );
}
