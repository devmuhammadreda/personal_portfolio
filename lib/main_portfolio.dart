import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';

import 'app.dart';
import 'core/di/injector.dart';
import 'core/firebase/firebase_bootstrapper.dart';
import 'core/services/bloc_observer.dart';
import 'features/portfolio/di/portfolio_dependencies.dart';

/// Entry point for the **portfolio** flavor (the public website).
///
/// Ships zero admin surface: no auth, no admin routes, no admin
/// dependency graph — release builds tree-shake all of it away. The
/// banner label is shown in debug mode only; release hides it.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = AppBlocObserver();
  FlavorConfig(
    name: kDebugMode ? 'PORTFOLIO' : '',
    variables: {'flavor': 'portfolio'},
  );
  configureCoreDependencies();
  configurePortfolioDependencies();
  await FirebaseBootstrapper.initialise();
  runApp(const PersonalPortfolioApp());
}
