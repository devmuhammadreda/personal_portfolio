import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:nested/nested.dart' show SingleChildWidget;

import 'core/di/injector.dart';
import 'core/services/bloc_observer.dart';
import 'core/supabase/supabase_bootstrapper.dart';
import 'app.dart';
import 'features/portfolio/di/portfolio_dependencies.dart';

/// Shared bootstrap — the single place owning the startup sequence.
///
/// Flavor entry points (`main_portfolio.dart`, `main_admin.dart`) only
/// declare their [FlavorConfig] and hand over their dependency wiring;
/// everything else — bindings, observer, core DI, Supabase, app config —
/// happens here, exactly once.
///
/// The flavor wiring arrives as a parameter instead of being switched on
/// here so no flavor ever gains an import path to another flavor's code
/// (the public bundle stays free of admin surface).
Future<void> runPersonalPortfolioApp({
  required void Function() configureFlavorDependencies,
  List<SingleChildWidget> extraProviders = const <SingleChildWidget>[],
  String title = 'Flutter Developer — Portfolio',
}) async {
  WidgetsFlutterBinding.ensureInitialized();

  // Observability
  Bloc.observer = AppBlocObserver();

  // Dependency graph: core first, then the flavor's own module.
  configureCoreDependencies();
  configureFlavorDependencies();

  // Backend
  await SupabaseBootstrapper.initialise();

  runApp(PersonalPortfolioApp(title: title, extraProviders: extraProviders));
}

/// Default entry point when no `-t` target is given — runs the
/// **portfolio** flavor with no banner label.
Future<void> main() => runPersonalPortfolioApp(
  configureFlavorDependencies: configurePortfolioDependencies,
);
