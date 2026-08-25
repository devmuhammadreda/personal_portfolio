import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../features/portfolio/presentation/pages/portfolio_page.dart';
import '../constants/app_constants.dart';

/// Router for the **portfolio** flavor.
///
/// Registers the public site only and hard-redirects every other location
/// (including `/admin/**`) back to home, so no admin surface is reachable
/// from this build.
GoRouter createPortfolioRouter() {
  return GoRouter(
    initialLocation: AppRoutes.home,
    redirect: (BuildContext context, GoRouterState state) {
      final bool atHome = state.matchedLocation == AppRoutes.home;
      return atHome ? null : AppRoutes.home;
    },
    routes: [
      GoRoute(
        path: AppRoutes.home,
        pageBuilder: (context, state) =>
            _fadePage(state, const PortfolioPage()),
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
      final CurvedAnimation curved = CurvedAnimation(
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
