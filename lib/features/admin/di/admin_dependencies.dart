import 'package:go_router/go_router.dart';

import '../../../core/di/injector.dart';
import '../../../core/router/auth_gate.dart';
import '../../portfolio/di/portfolio_dependencies.dart'
    show initPortfolioDataInjection;
import '../auth/di/auth_injection.dart';
import '../media/di/media_injection.dart';
import '../routing/admin_router.dart';

/// Flavor module for the **admin** build.
///
/// Composes the content data (dashboard/editors read the same profile
/// and projects as the public site) with the per-feature registrars
/// (auth, media) and adds the guarded admin router on top. Core
/// dependencies must be configured first (`configureCoreDependencies`).
void configureAdminDependencies() {
  initPortfolioDataInjection();
  initAuthInjection();
  initMediaInjection();
  getIt.registerLazySingleton<GoRouter>(
    () => createAdminRouter(getIt<AuthGate>()),
    dispose: (GoRouter router) => router.dispose(),
  );
}
