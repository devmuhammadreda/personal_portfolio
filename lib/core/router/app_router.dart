import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../constants/app_constants.dart';
import '../../features/admin/auth/presentation/pages/login_page.dart';
import '../../features/admin/presentation/pages/dashboard_page.dart';
import '../../features/portfolio/presentation/pages/portfolio_page.dart';
import 'auth_gate.dart';
import 'authentication_status.dart';

GoRouter createAppRouter(AuthGate authGate) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authGate,
    redirect: (BuildContext context, GoRouterState state) {
      final String location = state.matchedLocation;
      final bool isAdminRoute = location.startsWith('/admin');
      final bool isLoginRoute = location == AppRoutes.adminLogin;
      final bool authenticated =
          authGate.status == AuthenticationStatus.authenticated;

      if (isLoginRoute && authenticated) return AppRoutes.adminDashboard;
      if (isAdminRoute && !isLoginRoute && !authenticated) {
        return AppRoutes.adminLogin;
      }
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) => _fadePage(state, const PortfolioPage()),
      ),
      GoRoute(
        path: AppRoutes.adminLogin,
        pageBuilder: (context, state) => _fadePage(state, const LoginPage()),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        pageBuilder: (context, state) => _fadePage(state, const DashboardPage()),
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage(GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 320),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final curved = CurvedAnimation(
        parent: animation,
        curve: Curves.easeOutCubic,
      );
      return FadeTransition(
        opacity: curved,
        child: SlideTransition(
          position: Tween<Offset>(
            begin: const Offset(0, 0.015),
            end: Offset.zero,
          ).animate(curved),
          child: child,
        ),
      );
    },
  );
}
