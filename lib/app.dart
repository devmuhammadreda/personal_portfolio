import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_flavor/flutter_flavor.dart';
import 'package:go_router/go_router.dart';
import 'package:nested/nested.dart' show SingleChildWidget;

import 'core/di/injector.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_cubit.dart';

/// Root widget shared by both flavors.
///
/// Flavor entry points inject their own extra providers (e.g. the admin
/// [BlocProvider]) and title; everything else — theming, router config
/// and the flavor banner (label comes from `FlavorConfig`) — is handled
/// here.
class PersonalPortfolioApp extends StatelessWidget {
  const PersonalPortfolioApp({
    super.key,
    this.extraProviders = const <SingleChildWidget>[],
    this.title = 'Flutter Developer — Portfolio',
  });

  final List<SingleChildWidget> extraProviders;
  final String title;

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // App-scope cubits: theme (+ auth in the admin flavor, injected).
        BlocProvider<ThemeCubit>.value(value: getIt<ThemeCubit>()),
        ...extraProviders,
      ],
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return FlavorBanner(
            child: MaterialApp.router(
              title: title,
              debugShowCheckedModeBanner: false,
              theme: AppTheme.light,
              darkTheme: AppTheme.dark,
              themeMode: themeMode,
              routerConfig: getIt<GoRouter>(),
            ),
          );
        },
      ),
    );
  }
}
