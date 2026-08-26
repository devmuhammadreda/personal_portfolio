import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/constants/app_constants.dart';
import '../../portfolio/presentation/pages/portfolio_page.dart';
import '../auth/presentation/pages/login_page.dart';
import '../education_management/presentation/pages/education_form_page.dart';
import '../education_management/presentation/pages/educations_admin_page.dart';
import '../experience_management/presentation/pages/experience_form_page.dart';
import '../experience_management/presentation/pages/experiences_admin_page.dart';
import '../message_inbox/presentation/pages/messages_admin_page.dart';
import '../presentation/pages/dashboard_page.dart';
import '../presentation/widgets/admin_footer_badge.dart';
import '../presentation/widgets/admin_shell.dart';
import '../profile_management/presentation/pages/profile_editor_page.dart';
import '../project_management/presentation/pages/project_form_page.dart';
import '../project_management/presentation/pages/projects_admin_page.dart';
import '../../../core/router/auth_gate.dart';
import '../../../core/router/authentication_status.dart';

/// Router for the **admin** flavor.
///
/// Boots into the dashboard (redirecting to login while unauthenticated)
/// and keeps the public site reachable for live-content preview.
GoRouter createAdminRouter(AuthGate authGate) {
  return GoRouter(
    initialLocation: AppRoutes.adminDashboard,
    refreshListenable: authGate,
    redirect: (BuildContext context, GoRouterState state) {
      final String location = state.matchedLocation;
      final bool isAdminRoute = location.startsWith(AppRoutes.adminRoot);
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
        pageBuilder: (context, state) => _fadePage(
          state,
          const PortfolioPage(footerTrailing: AdminFooterBadge()),
        ),
      ),
      GoRoute(
        path: AppRoutes.adminLogin,
        pageBuilder: (context, state) => _fadePage(state, const LoginPage()),
      ),
      ShellRoute(
        pageBuilder: (context, state, child) =>
            _fadePage(state, AdminShell(child: child), keepShellAlive: true),
        routes: [
          GoRoute(
            path: AppRoutes.adminDashboard,
            pageBuilder: (context, state) =>
                _noTransition(state, const DashboardPage()),
          ),
          GoRoute(
            path: AppRoutes.adminProfile,
            pageBuilder: (context, state) =>
                _noTransition(state, const ProfileEditorPage()),
          ),
          GoRoute(
            path: AppRoutes.adminProjects,
            pageBuilder: (context, state) =>
                _noTransition(state, const ProjectsAdminPage()),
          ),
          GoRoute(
            path: AppRoutes.adminExperiences,
            pageBuilder: (context, state) =>
                _noTransition(state, const ExperiencesAdminPage()),
          ),
          GoRoute(
            path: AppRoutes.adminNewExperience,
            pageBuilder: (context, state) =>
                _noTransition(state, const ExperienceFormPage()),
          ),
          GoRoute(
            path: '${AppRoutes.adminExperiences}/:id',
            pageBuilder: (context, state) => _noTransition(
              state,
              ExperienceFormPage(experienceId: state.pathParameters['id']),
            ),
          ),
          GoRoute(
            path: AppRoutes.adminEducations,
            pageBuilder: (context, state) =>
                _noTransition(state, const EducationsAdminPage()),
          ),
          GoRoute(
            path: AppRoutes.adminNewEducation,
            pageBuilder: (context, state) =>
                _noTransition(state, const EducationFormPage()),
          ),
          GoRoute(
            path: '${AppRoutes.adminEducations}/:id',
            pageBuilder: (context, state) => _noTransition(
              state,
              EducationFormPage(educationId: state.pathParameters['id']),
            ),
          ),
          GoRoute(
            path: AppRoutes.adminMessages,
            pageBuilder: (context, state) =>
                _noTransition(state, const MessagesAdminPage()),
          ),
          GoRoute(
            path: AppRoutes.adminNewProject,
            pageBuilder: (context, state) =>
                _noTransition(state, const ProjectFormPage()),
          ),
          GoRoute(
            path: '${AppRoutes.adminProjects}/:id',
            pageBuilder: (context, state) => _noTransition(
              state,
              ProjectFormPage(projectId: state.pathParameters['id']),
            ),
          ),
        ],
      ),
    ],
  );
}

CustomTransitionPage<void> _fadePage(
  GoRouterState state,
  Widget child, {
  bool keepShellAlive = false,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: Duration(milliseconds: keepShellAlive ? 220 : 320),
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

NoTransitionPage<void> _noTransition(GoRouterState state, Widget child) {
  return NoTransitionPage<void>(key: state.pageKey, child: child);
}
