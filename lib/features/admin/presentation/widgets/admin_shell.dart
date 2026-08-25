import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/localizations_cubit/locale_cubit.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../../core/utils/responsive.dart';
import '../../../../core/widgets/language_toggle.dart';
import '../../../../core/widgets/theme_toggle.dart';
import '../../auth/presentation/cubit/auth_cubit.dart';

/// Layout frame for all authenticated admin pages: navigation rail on
/// desktop/tablet, bottom navigation bar on mobile.
final class AdminShell extends StatelessWidget {
  const AdminShell({super.key, required this.child});

  final Widget child;

  static const List<(int, IconData, String)> _destinations = [
    (0, Icons.dashboard_outlined, AppRoutes.adminDashboard),
    (1, Icons.person_outline_rounded, AppRoutes.adminProfile),
    (2, Icons.folder_open_outlined, AppRoutes.adminProjects),
  ];

  static String _label(AppLocalizations loc, int index) => switch (index) {
    0 => loc.shellDashboard,
    1 => loc.shellProfile,
    _ => loc.shellProjects,
  };

  int _selectedIndexFor(String location) {
    if (location.startsWith(AppRoutes.adminProjects)) return 2;
    if (location.startsWith(AppRoutes.adminProfile)) return 1;
    return 0;
  }

  void _go(BuildContext context, int index) {
    final String route = _destinations[index].$3;
    if (GoRouterState.of(context).matchedLocation == route) return;
    context.go(route);
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isCompact = context.isCompact;
    final String location = GoRouterState.of(context).matchedLocation;
    final int selectedIndex = _selectedIndexFor(location);

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            Container(
              width: 9,
              height: 9,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.primary,
                    theme.colorScheme.secondary,
                  ],
                ),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              context.loc.shellConsoleTitle,
              style: theme.textTheme.titleMedium,
            ),
          ],
        ),
        actions: [
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 6),
            child: Center(child: LanguageToggle()),
          ),
          const Padding(
            padding: EdgeInsetsDirectional.only(end: 6),
            child: Center(child: ThemeToggle()),
          ),
          IconButton(
            tooltip: context.loc.shellSignOut,
            onPressed: () => context.read<AuthCubit>().signOut(),
            icon: const Icon(Icons.logout_rounded),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Row(
        children: [
          if (!isCompact)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
              child: Card(
                child: NavigationRail(
                  extended: context.windowSize != WindowSize.tablet,
                  minExtendedWidth: 190,
                  selectedIndex: selectedIndex,
                  onDestinationSelected: (index) => _go(context, index),
                  leading: const SizedBox(height: 4),
                  destinations: [
                    for (final (index, icon, _) in _destinations)
                      NavigationRailDestination(
                        icon: Icon(icon),
                        selectedIcon: Icon(icon),
                        label: Text(_label(context.loc, index)),
                      ),
                  ],
                ),
              ),
            ),
          Expanded(child: child),
        ],
      ),
      bottomNavigationBar: isCompact
          ? NavigationBar(
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) => _go(context, index),
              destinations: [
                for (final (index, icon, _) in _destinations)
                  NavigationDestination(
                    icon: Icon(icon),
                    selectedIcon: Icon(icon),
                    label: _label(context.loc, index),
                  ),
              ],
            )
          : null,
    );
  }
}
